import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fuurutta/constants/constants.dart';
import 'package:fuurutta/core/deep_link/app_deep_link_manager.dart';
import 'package:fuurutta/main.dart';
import 'package:fuurutta/presentation/home/data/datasources/product_remote_data_source.dart';
import 'package:fuurutta/presentation/home/data/repositories/product_repository_impl.dart';
import 'package:fuurutta/presentation/home/domain/repositories/product_repository.dart';
import 'package:fuurutta/presentation/home/domain/usecases/get_products.dart';
import 'package:fuurutta/presentation/product_detail/data/datasources/ai_product_description_remote_data_source.dart';
import 'package:fuurutta/presentation/product_detail/data/datasources/product_detail_remote_data_source.dart';
import 'package:fuurutta/presentation/product_detail/data/repositories/ai_product_description_repository_impl.dart';
import 'package:fuurutta/presentation/product_detail/data/repositories/product_detail_repository_impl.dart';
import 'package:fuurutta/presentation/product_detail/domain/repositories/ai_product_description_repository.dart';
import 'package:fuurutta/presentation/product_detail/domain/repositories/product_detail_repository.dart';
import 'package:fuurutta/presentation/product_detail/domain/usecases/generate_ai_product_description.dart';
import 'package:fuurutta/presentation/product_detail/domain/usecases/get_product_detail.dart';
import 'package:fuurutta/routes.gr.dart';
import 'package:fuurutta/services/ai/gemini_service.dart';
import 'package:fuurutta/services/firebase_auth_services.dart';
import 'package:fuurutta/services/local_auth_services.dart';
import 'package:fuurutta/shared_pref/prefs.dart';
import 'package:fuurutta/utils/app_flavor_env.dart';
import 'package:fuurutta/utils/cache_manager.dart';
import 'package:fuurutta/utils/currency_converter/currency_converter_util.dart';
import 'package:fuurutta/utils/currency_converter/data/datasources/currency_converter_remote_data_source.dart';
import 'package:fuurutta/utils/currency_converter/data/repositories/currency_converter_repository_impl.dart';
import 'package:fuurutta/utils/currency_converter/domain/repositories/currency_converter_repository.dart';
import 'package:fuurutta/utils/currency_converter/domain/usecases/get_exchange_rate.dart';

final sl = GetIt.instance;
bool _isForceLoggingOutUser = false;

Future<void> configureDependencies({
  FirebaseAuth? firebaseAuth,
  GoogleSignIn? googleSignIn,
  FirebaseAuthService? firebaseAuthService,
  Dio? dio,
}) async {
  sl.registerLazySingleton<FirebaseAuth>(
    () => firebaseAuth ?? FirebaseAuth.instance,
  );

  sl.registerLazySingleton<GoogleSignIn>(
    () => googleSignIn ?? GoogleSignIn.instance,
  );

  sl.registerLazySingleton<FirebaseAuthService>(
    () =>
        firebaseAuthService ??
        FirebaseAuthService(
          firebaseAuth: sl<FirebaseAuth>(),
          googleSignIn: sl<GoogleSignIn>(),
        ),
  );

  final cacheManager = CacheManager();
  await cacheManager.initialize();
  sl.registerSingleton<CacheManager>(cacheManager);

  final baseUrl = AppConfig.baseUrl;
  final hasValidBaseUrl = Uri.tryParse(baseUrl)?.hasScheme ?? false;

  final pinnedDio = dio ??
      Dio(
        BaseOptions(
          baseUrl: hasValidBaseUrl ? baseUrl : 'https://localhost',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  if (!hasValidBaseUrl) {
    debugPrint('[DI] WARNING: No valid API base URL configured. '
        'API calls will not work.');
  }

  _registerDioInterceptor(pinnedDio);
  sl<CacheManager>().attachCacheInterceptor(pinnedDio);

  sl
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl()),
    )
    ..registerLazySingleton<ProductRemoteDatasource>(
      () => ProductRemoteDataSrcImpl(sl()),
    )
    ..registerLazySingleton(() => GetProductDetail(sl()))
    ..registerLazySingleton<ProductDetailRepository>(
      () => ProductDetailRepositoryImpl(sl()),
    )
    ..registerLazySingleton<ProductDetailRemoteDatasource>(
      () => ProductDetailRemoteDataSrcImpl(sl()),
    )
    ..registerLazySingleton(() => GenerateAIProductDescription(sl()))
    ..registerLazySingleton<AIProductDescriptionRepository>(
      () => AIProductDescriptionRepositoryImpl(sl()),
    )
    ..registerLazySingleton<AIProductDescriptionRemoteDataSource>(
      () => AIProductDescriptionRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton(() => GeminiService())
    ..registerLazySingleton(() => GetExchangeRate(sl()))
    ..registerLazySingleton<CurrencyConverterRepository>(
      () => CurrencyConverterRepositoryImpl(sl()),
    )
    ..registerLazySingleton<CurrencyConverterRemoteDatasource>(
      () => CurrencyConverterRemoteDataSrcImpl(sl()),
    )
    ..registerLazySingleton(() => CurrencyConverterUtil(sl()))
    ..registerLazySingleton<Dio>(() => pinnedDio)
    ..registerLazySingleton<AppDeepLinkManager>(() => AppDeepLinkManager())
    ..registerLazySingleton<LocalAuthService>(
      () => LocalAuthService(LocalAuthentication()),
    );
}

void _registerDioInterceptor(Dio dio) {
  final certHash = _getCertHash();
  dio.interceptors.addAll([
    if (certHash.isNotEmpty) ...[
      CertificatePinningInterceptor(
        allowedSHAFingerprints: [certHash],
        callFollowingErrorInterceptor: true,
      ),
      _sslPinningErrorInterceptor,
    ],
    _authErrorInterceptor(),
  ]);
}

InterceptorsWrapper get _sslPinningErrorInterceptor {
  return InterceptorsWrapper(
    onError: (DioException dioError, ErrorInterceptorHandler handler) async {
      if (dioError.error.toString().contains(kConnectionIsNotSecureError)) {
        debugPrint('[SSL Pinning] Connection is not secure!');

        await rootNavigatorKey.currentContext!.router
            .replaceAll([const SslConnectionFailedRoute()]);
      }

      handler.next(dioError);
    },
  );
}

InterceptorsWrapper _authErrorInterceptor() => InterceptorsWrapper(
      onError: (DioException dioError, ErrorInterceptorHandler handler) async {
        final statusCode = dioError.response?.statusCode ?? 0;

        debugPrint(
          '[AuthErrorInterceptor] status: $statusCode',
        );

        final shouldLogout =
            !_isForceLoggingOutUser && (statusCode == 401 || statusCode == 403);

        if (shouldLogout) {
          _isForceLoggingOutUser = true;
          try {
            await Prefs.clear();
            await sl<CacheManager>().clearCachedApiResponse();
            await sl<FirebaseAuthService>().signOut();

            final currentContext = rootNavigatorKey.currentContext;
            if (currentContext != null) {
              await currentContext.router
                  .replaceAll([LoginWithPhoneNumberRoute()]);
            } else {
              debugPrint(
                '[AuthErrorInterceptor] No navigator context available',
              );
            }
          } catch (e) {
            debugPrint('[AuthErrorInterceptor] Logout failed: $e');
          } finally {
            _isForceLoggingOutUser = false;
          }
        }

        handler.next(dioError);
      },
    );

String _getCertHash() {
  final certificateHash = AppConfig.getDioCertHash();
  if (certificateHash.isEmpty || certificateHash.length != 64) {
    debugPrint('[SSL Pinning] WARNING: No valid certificate hash for '
        '${AppConfig.appFlavor.name}. SSL pinning disabled.');
    return '';
  }

  debugPrint('[SSL Pinning] Using SHA-256 certHash: "$certificateHash"');
  return certificateHash;
}

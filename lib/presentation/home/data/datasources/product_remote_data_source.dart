import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fuurutta/core/errors/exceptions.dart';
import 'package:fuurutta/core/services/injection_container.dart';
import 'package:fuurutta/presentation/home/data/models/product_model.dart';
import 'package:fuurutta/utils/cache_manager.dart';
import 'package:fuurutta/utils/typedef.dart';

mixin ProductRemoteDatasource {
  Future<List<ProductModel>> getProducts();
}

const kGetProductEndpoint = '/products';

class ProductRemoteDataSrcImpl implements ProductRemoteDatasource {
  ProductRemoteDataSrcImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get(
        kGetProductEndpoint,
        options: sl<CacheManager>().defaultCacheOptions.toOptions(),
      );

      if (response.statusCode != 200) {
        throw APIException(
          message: response.data,
          statusCode: response.statusCode ?? 500,
        );
      }

      return List<DataMap>.from(response.data as List)
          .map((userData) => ProductModel.fromMap(userData))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}

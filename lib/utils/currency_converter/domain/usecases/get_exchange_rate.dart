
import 'package:fuurutta/core/usecase/usecase.dart';
import 'package:fuurutta/utils/currency_converter/domain/entities/currency_rate.dart';
import 'package:fuurutta/utils/currency_converter/domain/repositories/currency_converter_repository.dart';
import 'package:fuurutta/utils/typedef.dart';

class ExchangeRateParams {
  const ExchangeRateParams({
    required this.fromCurrency,
    required this.toCurrency,
  });

  final String fromCurrency;
  final String toCurrency;
}

class GetExchangeRate with UseCaseWithParams<CurrencyRate, ExchangeRateParams> {
  const GetExchangeRate(this._repository);

  final CurrencyConverterRepository _repository;

  @override
  ResultFuture<CurrencyRate> call(ExchangeRateParams params) async =>
      _repository.getExchangeRate(
        fromCurrency: params.fromCurrency,
        toCurrency: params.toCurrency,
      );
}

import 'package:fuurutta/utils/currency_converter/domain/entities/currency_rate.dart';
import 'package:fuurutta/utils/typedef.dart';

mixin CurrencyConverterRepository {
  ResultFuture<CurrencyRate> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  });
}

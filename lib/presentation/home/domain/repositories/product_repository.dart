import 'package:fuurutta/presentation/home/domain/entities/product.dart';
import 'package:fuurutta/utils/typedef.dart';

mixin ProductRepository {
  ResultFuture<List<Product>> getProducts();
}

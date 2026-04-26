import 'package:fuurutta/presentation/product_detail/domain/entities/product_detail.dart';
import 'package:fuurutta/utils/typedef.dart';

mixin ProductDetailRepository {
  ResultFuture<ProductDetail> getProductDetail({required String id});
}

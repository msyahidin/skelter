import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fuurutta/presentation/home/domain/entities/product.dart';
import 'package:fuurutta/presentation/home/widgets/product_category_chip.dart';
import 'package:fuurutta/presentation/home/widgets/product_image.dart';
import 'package:fuurutta/presentation/home/widgets/product_price_rating.dart';
import 'package:fuurutta/presentation/home/widgets/product_title.dart';
import 'package:fuurutta/routes.gr.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';
import 'package:fuurutta/widgets/styling/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(
        ProductDetailRoute(productId: product.id),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.currentTheme.bgSurfaceBase2,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
              color: AppColors.shadowColor3,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(imageUrl: product.image),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductCategoryChip(category: product.category),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductTitle(title: product.title),
                            const Spacer(),
                            ProductPriceRating(product: product),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

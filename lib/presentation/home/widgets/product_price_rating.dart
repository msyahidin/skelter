import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/presentation/home/domain/entities/product.dart';
import 'package:fuurutta/utils/currency_formatter_util.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class ProductPriceRating extends StatelessWidget {
  final Product product;

  const ProductPriceRating({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            CurrencyFormatterUtil.format(
              product.price.toString(),
              locale: context.localization.localeName,
            ),
            maxLines: 1,
            style: AppTextStyles.p3SemiBold.copyWith(
              color: context.currentTheme.textBrandPrimary,
            ),
          ),
        ),
        Icon(
          Icons.star,
          color: context.currentTheme.bgWarningHover,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          product.rating.toString(),
          style: AppTextStyles.p4Medium.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
        ),
      ],
    );
  }
}

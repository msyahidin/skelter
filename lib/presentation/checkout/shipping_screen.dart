import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/presentation/checkout/widget/order_summary.dart';
import 'package:fuurutta/presentation/checkout/widget/shipping_address.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.shipping_address,
          style: AppTextStyles.p2Bold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 16),
        const ShippingAddress(),
        const SizedBox(height: 16),
        const OrderSummary(),
        const SizedBox(height: 16),
      ],
    );
  }
}

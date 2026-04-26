import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/utils/extensions/build_context_ext.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';
import 'package:fuurutta/widgets/app_button/app_button.dart';
import 'package:fuurutta/widgets/app_button/enums/app_button_size_enum.dart';
import 'package:fuurutta/widgets/app_button/enums/app_button_style_enum.dart';

class ProductsHeadlineBar extends StatelessWidget {
  const ProductsHeadlineBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.localization.top_products,
          style: AppTextStyles.p2SemiBold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
        ),
        AppButton(
          style: AppButtonStyle.textOrIcon,
          size: AppButtonSize.medium,
          label: context.localization.see_all,
          onPressed: () => context.showSnackBar('See all products'),
        ),
      ],
    );
  }
}

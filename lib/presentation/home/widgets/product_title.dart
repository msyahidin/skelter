import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.p4SemiBold.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

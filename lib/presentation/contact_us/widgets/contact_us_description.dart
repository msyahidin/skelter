import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class ContactUsDescription extends StatelessWidget {
  const ContactUsDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.contact_us_message,
      style: AppTextStyles.p2Regular
          .copyWith(color: context.currentTheme.textNeutralPrimary),
    );
  }
}

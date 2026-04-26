import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class SubscriptionActivatedMessage extends StatelessWidget {
  const SubscriptionActivatedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.subscription_activated_message,
      style: AppTextStyles.p3Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

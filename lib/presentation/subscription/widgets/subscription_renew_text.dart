import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';

class SubscriptionRenewText extends StatelessWidget {
  const SubscriptionRenewText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.subscription_renew,
      style: AppTextStyles.p3Regular,
    );
  }
}

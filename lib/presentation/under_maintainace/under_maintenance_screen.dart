import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/gen/assets.gen.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

@RoutePage()
class UnderMaintenanceScreen extends StatelessWidget {
  const UnderMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.4,
              child: Lottie.asset(
                Assets.animations.appUnderMaintenance,
                width: 160,
                height: 160,
                repeat: false,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.localization.under_maintenance,
              style: AppTextStyles.p1SemiBold.copyWith(
                color: context.currentTheme.textNeutralPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.localization.under_maintenance_message,
              style: AppTextStyles.p3Regular.copyWith(
                color: context.currentTheme.textNeutralSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

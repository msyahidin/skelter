import 'package:flutter/material.dart';
import 'package:fuurutta/presentation/settings/widgets/account_security.dart';
import 'package:fuurutta/presentation/settings/widgets/biometric_authentication.dart';
import 'package:fuurutta/presentation/settings/widgets/change_password.dart';
import 'package:fuurutta/presentation/settings/widgets/choose_app_theme.dart';
import 'package:fuurutta/presentation/settings/widgets/divider.dart';
import 'package:fuurutta/presentation/settings/widgets/notification_settings.dart';
import 'package:fuurutta/presentation/settings/widgets/privacy_policy.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: context.currentTheme.strokeNeutralLight200),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Column(
            children: [
              NotificationSettings(),
              SettingsSectionDivider(),
              ChangePassword(),
              SettingsSectionDivider(),
              ChooseAppTheme(),
              SettingsSectionDivider(),
              AccountSecurity(),
              SettingsSectionDivider(),
              BiometricAuthentication(),
              SettingsSectionDivider(),
              PrivacyPolicy(),
            ],
          ),
        ),
      ],
    );
  }
}

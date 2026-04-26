import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/utils/extensions/build_context_ext.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        TablerIcons.lock,
        color: context.currentTheme.iconNeutralDefault,
      ),
      title: Text(
        context.localization.change_password,
        style: AppTextStyles.p2Regular.copyWith(
          color: context.currentTheme.textNeutralPrimary,
        ),
      ),
      trailing: Icon(
        TablerIcons.chevron_right,
        color: context.currentTheme.iconNeutralDefault,
      ),
      onTap: () {
        context.showSnackBar('Change Password');
      },
    );
  }
}

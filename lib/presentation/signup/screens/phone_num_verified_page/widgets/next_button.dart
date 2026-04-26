import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/routes.gr.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';
import 'package:fuurutta/widgets/app_button/app_button.dart';
import 'package:fuurutta/widgets/app_button/enums/app_button_size_enum.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: context.localization.next,
      foregroundColor: context.currentTheme.textNeutralLight,
      shouldSetFullWidth: true,
      size: AppButtonSize.large,
      onPressed: () {
        context.router.replace(const HomeRoute());
      },
    );
  }
}

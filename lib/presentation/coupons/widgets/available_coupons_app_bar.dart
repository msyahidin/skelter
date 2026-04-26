import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';
import 'package:fuurutta/widgets/app_button/app_button.dart';
import 'package:fuurutta/widgets/app_button/enums/app_button_size_enum.dart';

class ApplyCouponsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ApplyCouponsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AppButton.icon(
        iconData: TablerIcons.arrow_left,
        iconOrTextColorOverride: context.currentTheme.iconNeutralDefault,
        size: AppButtonSize.extraLarge,
        onPressed: () {
          context.maybePop();
        },
      ),
      title: Text(
        context.localization.available_coupons,
        style: AppTextStyles.h6SemiBold.copyWith(
          color: context.currentTheme.textNeutralPrimary,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

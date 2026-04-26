import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/gen/assets.gen.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/presentation/login/bloc/login_bloc.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class HeadingWelcomeWidget extends StatelessWidget {
  const HeadingWelcomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSignup = context.select<LoginBloc, bool>(
      (bloc) => bloc.state.isSignup,
    );

    return Column(
      children: [
        const SizedBox(height: 16),
        Image.asset(
          context.themeAsset(
            light: Assets.icons.companyLogoLt.path,
            dark: Assets.icons.companyLogoDt.path,
          ),
          width: 100,
          height: 56,
        ),
        const SizedBox(height: 16),
        Text(
          isSignup
              ? context.localization.lets_get_started
              : context.localization.welcome_back,
          style: AppTextStyles.h2Bold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          isSignup
              ? context.localization.lets_get_started_info
              : context.localization.enter_your_registered_phone_number,
          style: AppTextStyles.p2Regular.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

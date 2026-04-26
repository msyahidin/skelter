import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:fuurutta/presentation/subscription/bloc/subscription_event.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';
import 'package:fuurutta/widgets/app_button/app_button.dart';
import 'package:fuurutta/widgets/app_button/enums/app_button_size_enum.dart';

class RetryPaymentButton extends StatelessWidget {
  const RetryPaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: context.localization.retry_payment,
      shouldSetFullWidth: true,
      backgroundColor: context.currentTheme.bgBrandDefault,
      foregroundColor: context.currentTheme.textNeutralLight,
      size: AppButtonSize.extraLarge,
      onPressed: () => context
          .read<SubscriptionBloc>()
          .add(const FetchSubscriptionPackagesEvent()),
    );
  }
}

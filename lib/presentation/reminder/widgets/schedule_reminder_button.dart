import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/presentation/reminder/bloc/reminder_bloc.dart';
import 'package:fuurutta/presentation/reminder/bloc/reminder_event.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';
import 'package:fuurutta/widgets/app_button/app_button.dart';
import 'package:fuurutta/widgets/app_button/enums/app_button_size_enum.dart';

class ScheduleReminderButton extends StatelessWidget {
  const ScheduleReminderButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<ReminderBloc, bool>(
      (bloc) => bloc.state.isLoading,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: AppButton(
        foregroundColor: context.currentTheme.textNeutralLight,
        size: AppButtonSize.extraLarge,
        onPressed: () {
          if (isLoading) return;
          context.read<ReminderBloc>().add(ScheduleReminderEvent());
        },
        label: context.localization.schedule_reminder,
        isLoading: isLoading,
      ),
    );
  }
}

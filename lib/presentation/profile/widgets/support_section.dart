import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/i18n/localization.dart';
import 'package:fuurutta/presentation/profile/widgets/contact_us.dart';
import 'package:fuurutta/presentation/profile/widgets/divider.dart';
import 'package:fuurutta/presentation/profile/widgets/feedback_and_rating.dart';
import 'package:fuurutta/presentation/profile/widgets/help_and_support.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.support,
          style: AppTextStyles.h6SemiBold.copyWith(
            color: context.currentTheme.textNeutralPrimary,
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: context.currentTheme.strokeNeutralLight200),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Column(
            children: [
              FeedbackAndRating(),
              ProfileItemsDivider(),
              HelpAndSupport(),
              ProfileItemsDivider(),
              ContactUs(),
            ],
          ),
        ),
      ],
    );
  }
}

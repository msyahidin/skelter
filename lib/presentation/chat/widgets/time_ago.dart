import 'package:flutter/material.dart';
import 'package:fuurutta/common/theme/text_style/app_text_styles.dart';
import 'package:fuurutta/presentation/chat/model/chat_message_model.dart';
import 'package:fuurutta/utils/extensions/date_time_extensions.dart';
import 'package:fuurutta/utils/theme/extention/theme_extension.dart';

class TimeAgo extends StatelessWidget {
  const TimeAgo({
    super.key,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Text(
          '${message.date.to12HourFormat()}${message.isSentByMe ? ' '
              '• ${message.status}' : ''}',
          style: AppTextStyles.c2Medium
              .copyWith(color: context.currentTheme.textNeutralSecondary),
        ),
      ],
    );
  }
}

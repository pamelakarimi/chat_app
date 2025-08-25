
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:intl/intl.dart';

import '../../features/chat/domain/entities/message_entity.dart';

class ChatBubble extends StatelessWidget {
  final MessageEntity message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.isSentByMe;

    // Format the timestamp to 'HH:mm' using DateFormat.
    final String formattedTime = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            // Applying the fixed dimensions you provided.
            width: 273.55,
            height: 114.68,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              // Using the colors from your AppColors file.
              color: isMe ? AppColors.bubbleColorMe : AppColors.bubbleColorOther,
              // Applying the uniform 9.92px border radius to all corners.
              borderRadius: BorderRadius.circular(9.92),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: isMe ? AppColors.textBubbleMe : AppColors.textBubbleOther,
                fontSize: 16,
              ),
            ),
          ),
          // Moved timestamp and ticks outside the bubble, with a small top margin.
          // This section is now only shown for outgoing messages (isMe).
          if (isMe)
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Timestamp
                  Text(
                    formattedTime, // Use the new formatted time string.
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Double tick icon, visible only for messages sent by "me".
                  const Icon(
                    Icons.done_all,
                    size: 16,
                    color: AppColors.iconTickColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

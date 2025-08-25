import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onSubmitted;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // The message input field is placed inside a Container.
      children: [
        Container(
          // Set the background color for the input area.
          decoration: BoxDecoration(
            color: AppColors.chatAreaBackground,
            // Add a black outline to the input area.
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(12.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: onSubmitted,
                  decoration: const InputDecoration(
                    hintText: 'Enter message',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                ),
              ),
          
            ],
          ),
        ),
        // Added a new row for the bottom buttons.
        Padding(
          // Added a right padding of 12.0 to give space on the right.
          padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
          child: Row(
            // Changed alignment to align buttons to the right.
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // "End session" button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement end session logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.endSessionColor,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    // Changed border radius to 4.0.
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('End session'),
              ),
              const SizedBox(width: 8),
              // "Send" button with icon
              ElevatedButton.icon(
                onPressed: onSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bubbleColorMe,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    // Changed border radius to 4.0.
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.send),
                label: const Text('Send'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

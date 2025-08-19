import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isSentByMe;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
  });

  @override
  List<Object?> get props => [id, senderId, text, timestamp, isSentByMe];
}
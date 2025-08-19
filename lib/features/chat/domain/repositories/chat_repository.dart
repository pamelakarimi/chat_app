import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';


abstract class ChatRepository {
  Future<Either<Failure, List<MessageEntity>>> getChatHistory();
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message);
}
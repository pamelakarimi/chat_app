import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';


class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, MessageEntity>> call(MessageEntity message) async {
    return await repository.sendMessage(message);
  }
}
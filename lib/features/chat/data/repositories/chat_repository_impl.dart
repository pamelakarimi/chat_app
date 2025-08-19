
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MessageEntity>>> getChatHistory() async {
    try {
      final remoteMessages = await remoteDataSource.getChatHistory();
      localDataSource.cacheChatHistory(remoteMessages);
      return Right(remoteMessages);
    } on ServerFailure {
      try {
        final localMessages = await localDataSource.getChatHistory();
        return Right(localMessages);
      } on CacheFailure {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message) async {
    try {
      // Cast the MessageEntity to MessageModel to access the toJson() method
      final MessageModel messageModel = message as MessageModel;
      final sentMessage = await remoteDataSource.sendMessage(messageModel);
      return Right(sentMessage);
    } on ServerFailure {
      return Left(ServerFailure());
    } on Exception {
      // Fallback for an invalid cast or other exceptions
      return Left(ServerFailure());
    }
  }
}

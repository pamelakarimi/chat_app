

import 'dart:async';

import '../../../../core/error/failures.dart';
import '../models/message_model.dart';


abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getChatHistory();
  Future<void> cacheChatHistory(List<MessageModel> messages);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  //  in-memory cache 
  List<MessageModel> _cachedMessages = [];

  @override
  Future<List<MessageModel>> getChatHistory() async {
    if (_cachedMessages.isNotEmpty) {
      return _cachedMessages;
    } else {
      throw CacheFailure();
    }
  }

  @override
  Future<void> cacheChatHistory(List<MessageModel> messages) async {
    _cachedMessages = messages;
  }
}

import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/di.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/get_messages.dart';
import 'package:chat_app/features/chat/domain/usecases/send_messages.dart';
import 'package:chat_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


// Create a mock repository to control behavior during tests.
class FakeChatRepository implements ChatRepository {
  List<MessageEntity> _messages = [];
  Failure? _failure;

  void setMessages(List<MessageEntity> messages) {
    _messages = messages;
    _failure = null;
  }

  void setFailure(Failure failure) {
    _failure = failure;
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getChatHistory() async {
    if (_failure != null) {
      return Left(_failure!);
    }
    return Right(_messages);
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message) async {
    if (_failure != null) {
      return Left(_failure!);
    }
    // Correctly return a MessageEntity to match the contract.
    return Right(MessageEntity(
      id: 'mock_id',
      senderId: message.senderId,
      text: message.text,
      timestamp: message.timestamp,
      isSentByMe: message.isSentByMe,
    ));
  }
}

void main() {
  late FakeChatRepository fakeChatRepository;
  late ChatCubit chatCubit;
  late GetMessages getMessages;
  late SendMessage sendMessage;

  setUp(() {
    EquatableConfig.stringify = true;
    fakeChatRepository = FakeChatRepository();
    getMessages = GetMessages(fakeChatRepository);
    sendMessage = SendMessage(fakeChatRepository);
    chatCubit = ChatCubit(getMessages: getMessages, sendMessage: sendMessage);
    ChatInjectionContainer.chatCubit = chatCubit;
  });

  group('ChatPage', () {
    testWidgets('displays a loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        BlocProvider<ChatCubit>(
          create: (_) => ChatInjectionContainer.chatCubit,
          child: const MaterialApp(home: ChatPage()),
        ),
      );

      // The cubit will emit ChatLoading state immediately upon initialization
      // so we can expect to find a CircularProgressIndicator.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

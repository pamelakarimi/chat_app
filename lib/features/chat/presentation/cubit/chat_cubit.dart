


import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_messages.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;

  ChatCubit({
    required this.getMessages,
    required this.sendMessage,
  }) : super(ChatInitial());

  Future<void> fetchChatHistory() async {
    emit(ChatLoading());
    final result = await getMessages();
    result.fold(
      (failure) => emit(ChatError(failure.toString())),
      (messages) => emit(ChatLoaded(messages)),
    );
  }

  Future<void> sendNewMessage(String text) async {
    if (state is ChatLoaded) {
      final loadedState = state as ChatLoaded;
      
      // Create and optimistically add the outgoing message.
      final outgoingMessage = MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'me',
        text: text,
        timestamp: DateTime.now(),
        isSentByMe: true,
      );
      final updatedMessages = [...loadedState.messages, outgoingMessage];
      emit(ChatLoaded(updatedMessages));

      // Simulate sending the message to the backend.
      final result = await sendMessage(outgoingMessage);
      result.fold(
        (failure) {
          emit(const ChatError('Failed to send message.'));
        },
        (sentMessage) {
          // The message was successfully sent. Now, simulate a reply.
          
          Future.delayed(const Duration(milliseconds: 500), () {
            if (state is ChatLoaded) {
              final updatedState = state as ChatLoaded;
              final incomingMessage = MessageEntity(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                senderId: 'other',
                text: 'Echo: $text', // A simple echo to show a reply.
                timestamp: DateTime.now(),
                isSentByMe: false,
              );
              final finalMessages = [...updatedState.messages, incomingMessage];
              emit(ChatLoaded(finalMessages));
            }
          });
        },
      );
    }
  }
}

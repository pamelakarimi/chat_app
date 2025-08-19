
import 'package:http/http.dart' as http;

import 'features/chat/data/datasources/chat_local_datasource.dart';
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_messages.dart';
import 'features/chat/domain/usecases/send_messages.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';

class ChatInjectionContainer {
  static late ChatCubit chatCubit;
  static late ChatRemoteDataSource remoteDataSource;
  static late ChatLocalDataSource localDataSource;
  static late ChatRepository chatRepository;
  static late GetMessages getMessages;
  static late SendMessage sendMessage;

  static void init() {
    // Data Sources
    remoteDataSource = ChatRemoteDataSourceImpl(client: http.Client());
    localDataSource = ChatLocalDataSourceImpl();

    // Repository
    chatRepository = ChatRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    // Use Cases
    getMessages = GetMessages(chatRepository);
    sendMessage = SendMessage(chatRepository);

    // Cubit
    chatCubit = ChatCubit(
      getMessages: getMessages,
      sendMessage: sendMessage,
    );
  }
}

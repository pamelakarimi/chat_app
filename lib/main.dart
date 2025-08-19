

import 'package:chat_app/di.dart';
import 'package:chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Initialize the dependency injection container.
  ChatInjectionContainer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // The BlocProvider creates the ChatCubit, which already has its
      // dependencies (use cases) injected via the DI container.
      create: (_) => ChatInjectionContainer.chatCubit,
      child: MaterialApp(
        title: 'Flutter Chat App',
        theme: AppTheme.lightTheme,
        home: const ChatPage(),
      ),
    );
  }
}

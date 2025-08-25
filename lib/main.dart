

import 'package:chat_app/di.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/chat/presentation/pages/chat_page.dart';
import 'features/chat/presentation/pages/ws_chart.dart';


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
       //home: const WsChatPage(user: "Alice", room: "general"),
      ),
    );
  }
}

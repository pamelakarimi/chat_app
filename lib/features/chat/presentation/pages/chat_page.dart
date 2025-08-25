// lib/features/chat/presentation/pages/chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/chat_bubble.dart';
import '../../../../core/widgets/message_input.dart';
import '../cubit/chat_cubit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().fetchChatHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatAreaBackground,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 1,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/nenacall_logo.png',
              height: 30,
            ),
            const SizedBox(width: 8),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle side navigation logic.
            },
          ),
          const SizedBox(width: 8),
        ],
           ),
      body: Column(
        children: [
          // User profile header below the AppBar.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
            ),
            child: Row(
              children: [
                // Profile avatar
                const CircleAvatar(
                  backgroundColor: Color(0xFF1800AD),
                  child: Text(
                    'J',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                // User name and number
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '98776',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Call icon
                IconButton(
                  icon: const Icon(Icons.call_outlined, color: Colors.black),
                  onPressed: () {
                    // Handle call action
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocListener<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                }
              },
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return ChatBubble(message: message);
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(child: Text('Start chatting!'));
                },
              ),
            ),
          ),
          MessageInput(
            controller: _controller,
            onSend: () {
              if (_controller.text.isNotEmpty) {
                context.read<ChatCubit>().sendNewMessage(_controller.text);
                _controller.clear();
              }
            },
            onSubmitted: (text) {
              if (text.isNotEmpty) {
                context.read<ChatCubit>().sendNewMessage(text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

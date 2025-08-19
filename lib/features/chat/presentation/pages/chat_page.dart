

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.bubbleColorOther,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
        
              backgroundImage: AssetImage('assets/images/profile_pic.png'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Karimi', style: AppStyles.chatName),
                Text('+254700123456', style: AppStyles.chatStatus),
              ],
            ),
          ],
        ),
        actions: [
        
          IconButton(
            icon: const Icon(Icons.call, color: AppColors.iconColor),
            onPressed: () {},
          ),
       
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
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

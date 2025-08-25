import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsChatPage extends StatefulWidget {
  final String user;
  final String room;

  const WsChatPage({super.key, required this.user, required this.room});

  @override
  State<WsChatPage> createState() => _WsChatPageState();
}

class _WsChatPageState extends State<WsChatPage> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();

    // Connect to WS
    channel = WebSocketChannel.connect(
      Uri.parse("ws://localhost:8080"), // Android emulator -> localhost
    );

    // Join the room
    channel.sink.add(jsonEncode({
      "type": "join",
      "room": widget.room,
      "user": widget.user,
    }));

    // Listen for messages
    channel.stream.listen((data) {
      final decoded = jsonDecode(data);

      if (decoded["type"] == "history") {
        setState(() {
          _messages.clear();
          _messages.addAll(List<Map<String, dynamic>>.from(decoded["messages"]));
        });
      } else if (decoded["type"] == "chat") {
        setState(() {
          _messages.add(Map<String, dynamic>.from(decoded["message"]));
        });
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    channel.sink.add(jsonEncode({
      "type": "chat",
      "message": _controller.text.trim(),
    }));

    _controller.clear();
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat - ${widget.room}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  title: Text(msg["user"] ?? "Unknown"),
                  subtitle: Text(msg["message"] ?? ""),
                  trailing: Text(
                    msg["time"] != null
                        ? DateTime.parse(msg["time"]).toLocal().toString().substring(11, 16)
                        : "",
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Enter message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}












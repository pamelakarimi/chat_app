
// Fetches data from a JSON mock server.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../models/message_model.dart';


abstract class ChatRemoteDataSource {
  Future<List<MessageModel>> getChatHistory();
  Future<MessageModel> sendMessage(MessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ChatRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'http://localhost:3000',
  });

  @override
  Future<List<MessageModel>> getChatHistory() async {
    final uri = Uri.parse('$baseUrl/messages');
    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MessageModel.fromJson(json)).toList();
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<MessageModel> sendMessage(MessageModel message) async {
    final uri = Uri.parse('$baseUrl/messages');
    try {
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(message.toJson()),
      );
      if (response.statusCode == 201) { 
        // 201 Created is the expected status code from json-server
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return MessageModel.fromJson(jsonMap);
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}

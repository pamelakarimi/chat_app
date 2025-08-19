import 'package:http/http.dart' as http;

import '../error/failures.dart';


class ApiClient {
  final http.Client client;

  ApiClient({required this.client});

  Future<String> get(String url) async {
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }

  Future<String> post(String url, {required dynamic body}) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        body: body,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw NetworkFailure();
    }
  }
}
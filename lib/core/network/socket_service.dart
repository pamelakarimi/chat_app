import 'dart:async';

class SocketService {
  final StreamController<String> _messageStreamController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageStreamController.stream;

  Future<void> connect() async {
    
    //  mock.
    print('Connecting to socket...');
    await Future.delayed(const Duration(milliseconds: 500));
    print('Socket connected.');
  }

  void sendMessage(String message) {
    // Mock sending a message. 
    print('Sending message: $message');
    // Simulate an echo or server response
    Future.delayed(const Duration(milliseconds: 100), () {
      _messageStreamController.add('Server echo: $message');
    });
  }

  void dispose() {
    _messageStreamController.close();
  }
}
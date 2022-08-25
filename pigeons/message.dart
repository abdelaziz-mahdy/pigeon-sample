import 'package:pigeon/pigeon.dart';

class Message {
  final String subject;
  final String body;
  final String email;

  Message(this.subject, this.body, this.email);
}

@HostApi()
abstract class MessageApi {
  List<Message> getMessages(String email);
}
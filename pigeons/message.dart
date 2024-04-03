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

class PyTorchRect {
  double left;
  double top;
  double right;
  double bottom;
  double width;
  double height;
  PyTorchRect(
      this.left, this.top, this.width, this.height, this.right, this.bottom);
}

@HostApi()
abstract class PyTorchApi {
  List<PyTorchRect> getRects();
}

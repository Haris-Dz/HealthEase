import 'package:healthease_desktop/models/message.dart';
import 'package:healthease_desktop/providers/base_provider.dart';

class MessagesProvider extends BaseProvider<Message> {
  MessagesProvider() : super("Message");
  @override
  Message fromJson(data) {
    // TODO: implement fromJson
    return Message.fromJson(data);
  }
}

import 'package:healthease_mobile/models/app_notification.dart';
import 'package:healthease_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class NotificationsProvider extends BaseProvider<AppNotification> {
  NotificationsProvider() : super("Notification");
  @override
  AppNotification fromJson(data) {
    // TODO: implement fromJson
    return AppNotification.fromJson(data);
  }

  Future<void> markAsRead(int id) async {
    var endpoint = "Notification/$id/mark-as-read";
    var baseUrl = BaseProvider.baseUrl;
    var url = "$baseUrl$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    final response = await http.patch(uri, headers: headers);
    if (!isValidResponse(response)) {
      throw Exception("Failed to mark as read");
    }
  }
}

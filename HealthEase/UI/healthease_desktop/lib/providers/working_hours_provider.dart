import 'dart:convert';

import 'package:healthease_desktop/models/working_hours.dart';
import 'package:healthease_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class WorkingHoursProvider extends BaseProvider<WorkingHours> {
  WorkingHoursProvider() : super("WorkingHours");

  @override
  WorkingHours fromJson(data) {
    return WorkingHours.fromJson(data);
  }

  Future<void> bulkUpsert(List<Map<String, dynamic>> body) async {
    final url = Uri.parse("${BaseProvider.baseUrl}WorkingHours/BulkUpsert");
    final headers = createHeaders();
    final jsonBody = jsonEncode(body);

    final response = await http.post(url, headers: headers, body: jsonBody);
    if (!isValidResponse(response)) {
      throw Exception("Failed to update working hours.");
    }
  }
}

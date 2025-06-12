import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/admin_report_summary.dart';
import 'auth_provider.dart';

class AdminReportProvider with ChangeNotifier {
  static String? baseUrl = const String.fromEnvironment(
    "baseUrl",
    defaultValue: "http://localhost:5200/api/",
  );

  AdminReportSummary? _report;
  bool _isLoading = false;
  String? _error;

  AdminReportSummary? get report => _report;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchReportSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String url = "${baseUrl}report/summary";
      Map<String, String> queryParams = {};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      if (queryParams.isNotEmpty) {
        url = "$url?${_getQueryString(queryParams)}";
      }

      var uri = Uri.parse(url);
      var headers = _createHeaders();

      var response = await http.get(uri, headers: headers);

      if (response.statusCode < 299) {
        var data = jsonDecode(response.body);
        _report = AdminReportSummary.fromJson(data);
        _error = null;
      } else if (response.statusCode == 401) {
        _error = "Unauthorized!";
      } else {
        _error = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Network error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _report = null;
    _error = null;
    notifyListeners();
  }

  Map<String, String> _createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    return {"Content-Type": "application/json", "Authorization": basicAuth};
  }

  String _getQueryString(Map<String, String> params) {
    return params.entries
        .map((e) => "${e.key}=${Uri.encodeComponent(e.value)}")
        .join('&');
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/search_result.dart';
import 'auth_provider.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? baseUrl;
  String _endpoint = "";

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5181/api/");
  }

  Future<SearchResult<T>> get(
      {dynamic filter,
      int? page,
      int? pageSize,
      bool? retrieveAll,
      String? orderBy,
      String? sortDirection,
      String? includeTables}) async {
    var url = "$baseUrl$_endpoint";

    Map<String, dynamic> queryParams = {};
    if (filter != null) {
      queryParams.addAll(filter);
    }
    if (page != null) {
      queryParams['page'] = page;
    }
    if (pageSize != null) {
      queryParams['pageSize'] = pageSize;
    }
    if (retrieveAll != null) {
      queryParams['retrieveAll'] = retrieveAll;
    }
    if (orderBy != null) {
      queryParams['orderBy'] = orderBy;
    }
    if (sortDirection != null) {
      queryParams['sortDirection'] = sortDirection;
    }
    if (includeTables != null) {
      queryParams['includeTables'] = includeTables;
    }
    if (queryParams.isNotEmpty) {
      var queryString = getQueryString(queryParams);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = data['count'];

      for (var item in data['resultList']) {
        result.resultList.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> getById(int id) async {
    var url = "$baseUrl$_endpoint/$id";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future delete(int id) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw new Exception("Deletion error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw UserFriendlyException("Unauthorized");
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        if (errorResponse is Map<String, dynamic> &&
            errorResponse['errors'] != null &&
            errorResponse['errors']['userError'] != null) {
          throw UserFriendlyException(
              errorResponse['errors']['userError'].join(', '));
        } else {
          throw UserFriendlyException(
              "Something bad happened, please try again");
        }
      } catch (e) {
        if (e is UserFriendlyException) {
          throw e;
        }
        throw UserFriendlyException("Something bad happened, please try again");
      }
    }
  }

  Map<String, String> createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}

class UserFriendlyException implements Exception {
  final String message;

  UserFriendlyException(this.message);

  @override
  String toString() => message;
}
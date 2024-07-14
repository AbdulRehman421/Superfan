import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static Future<String> get jwttoken async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken') ?? '';
  }
  // static const String jwttoken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJkYmE5MmE2Mi02N2Y3LTQ4YmYtODg5Yi1lODI0ZTE3ZmQ4ZWQiLCJpYXQiOjE3MjA0MzI0MzcsImV4cCI6MTcyMDQzNjAzN30.zoEbK59HMMa4tpBbF1F4h9qkvO6K9SJFOdCOnz12QF4';
  static const String baseUrl = 'https://api.mukeshnaraniya.com';
}
class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal();

  final http.Client _client = http.Client();

  Future<http.Response> get(
      String url, {
        Map<String, String>? headers,
      }) async {
    return _performRequest(() {
      return _client.get(
        Uri.parse(url),
        headers: headers,
      );
    });
  }

  Future<http.Response> post(
      String url, {
        Map<String, String>? headers,
        Object? body,
      }) async {
    return _performRequest(() {
      return _client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
    });
  }

  Future<http.Response> _performRequest(Future<http.Response> Function() request) async {
    http.Response response = await request();

    if (response.statusCode == 401) {
      // Token expired, refresh it
      final newToken = await _refreshJwtToken();
      if (newToken != null) {
        // Retry the request with the new token
        final newHeaders = <String, String>{...response.request?.headers ?? {}, 'Authorization': 'Bearer $newToken'};
        response = await request();
      }
    }

    return response;
  }

  Future<String?> _refreshJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      throw Exception('No refresh token found');
    }

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/refresh_token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newToken = responseData['token'];
      await prefs.setString('jwtToken', newToken);
      print('new token $newToken');
      return newToken;
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}

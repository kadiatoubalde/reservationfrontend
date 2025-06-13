import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Import kDebugMode
import 'dart:io'; // Import Platform

class ApiService {
  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    // For web, use localhost
    if (kIsWeb) {
      return 'http://localhost:8080';
    }

    // For Android emulator, use 10.0.2.2
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...headers,
      'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String endpoint, {String? token, Map<String, dynamic>? queryParams}) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(uri, headers: headers);
    return response;
  }

  static Future<http.Response> post(String endpoint, dynamic data, {String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: token != null ? getAuthHeaders(token) : headers,
      body: json.encode(data),
    );
    return response;
  }

  static Future<http.Response> put(String endpoint, dynamic data, {String? token}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: token != null ? getAuthHeaders(token) : headers,
      body: json.encode(data),
    );
    return response;
  }

  static Future<http.Response> delete(String endpoint, {String? token}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: token != null ? getAuthHeaders(token) : headers,
    );
    return response;
  }
} 
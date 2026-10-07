import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@singleton
class ApiClient {
  static const _baseUrl = 'https://api.coingecko.com/api/v3';
  static const _apiKey = 'CG-LrEwdCwhJe6RH1cbFgtot9DG';

  Future<List<dynamic>> get(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final url = _buildUrl(path, queryParams);
    final response = await http.get(url);
    final decode = jsonDecode(response.body);
    return decode;
  }

  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    final url = _buildUrl(path, queryParams);
    final response = await http.get(url);
    final decode = jsonDecode(response.body);
    return decode as Map<String, dynamic>;
  }

  Uri _buildUrl(String path, Map<String, String>? queryParams) {
    return Uri.parse(
      '$_baseUrl$path',
    ).replace(queryParameters: {...?queryParams, 'x_cg_demo_api_key': _apiKey});
  }
}

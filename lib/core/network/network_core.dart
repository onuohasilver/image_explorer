import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_explorer/core/core.dart';

class Network {
  final http.Client? _client;

  const Network([this._client]);

  Future<http.Response> post(String url, {String? token, Map? body}) async {
    http.Client client = _client ?? http.Client();
    try {
      http.Response response = await client.post(
          Uri.parse(const Api.dev().host + url),
          headers: _generateHeaders(token),
          body: jsonEncode(body));
      log(response.body);
      if ([201, 200].contains(response.statusCode)) return response;
      throw (CustomResponse(false, jsonDecode(response.body)['message']));
    } on SocketException {
      throw (CustomResponse(false, 'Network time out'));
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  Future<http.Response> get(String url, {String? token}) async {
    http.Client client = _client ?? http.Client();
    try {
      http.Response response = await client.get(
          Uri.parse(const Api.dev().host + url),
          headers: _generateHeaders(token));

      if ([201, 200].contains(response.statusCode)) return response;
      print(response.statusCode);
      throw (CustomResponse(false, "An unexpected error occured"));
    } on SocketException {
      throw (CustomResponse(false, 'Network time out'));
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }
}

///Generates headers given a Bearer toen
_generateHeaders(String? token, {bool withFile = false}) {
  if (withFile) {
    return {
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': '$token'
    };
  }
  return token != null
      ? {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        }
      : {
          'Accept': '*/*',
        };
}

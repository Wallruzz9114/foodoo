import 'dart:convert';

import 'package:async/async.dart';

import 'package:auth/src/core/adapters/i_auth_api.dart';
import 'package:auth/src/core/apis/mapper.dart';
import 'package:auth/src/models/objects/credentials.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPI implements IAuthAPI {
  AuthenticationAPI(this.baseUrl, this._client);

  final http.Client _client;
  String baseUrl;

  @override
  Future<Result<String>> signIn(Credentials credentials) async {
    final String endpoint = '$baseUrl/auth/signin';
    return _postCredential(endpoint, credentials);
  }

  @override
  Future<Result<String>> signUp(Credentials credentials) async {
    final String endpoint = '$baseUrl/auth/signup';
    return _postCredential(endpoint, credentials);
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    final Uri url = Uri(path: '$baseUrl/auth/signout');
    final Map<String, String> headers = <String, String>{
      'Content-type': 'application/json',
      'Authorization': token.value
    };
    final http.Response response = await _client.post(url, headers: headers);

    if (response.statusCode != 200) {
      return Result<bool>.value(false);
    }

    return Result<bool>.value(true);
  }

  Future<Result<String>> _postCredential(
    String endpoint,
    Credentials credential,
  ) async {
    final Uri uri = Uri(path: endpoint);
    final http.Response response = await _client.post(
      uri,
      body: Mapper.toJson(credential),
    );

    if (response.statusCode != 200) {
      return Result<String>.error('Server error');
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (json.isEmpty) {
      return Result<String>.error('Server error');
    }

    return json['auth_token'] != null
        ? Result<String>.value(json['auth_token'] as String)
        : Result<String>.error(json['message'] as String);
  }
}

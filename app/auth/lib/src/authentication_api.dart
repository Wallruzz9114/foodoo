import 'dart:convert';

import 'package:async/async.dart';

import 'package:auth/src/core/adapters/i_auth_api.dart';
import 'package:auth/src/core/apis/mapper.dart';
import 'package:auth/src/models/objects/sign_in_credentials.dart';
import 'package:auth/src/models/objects/sign_up_credentials.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPI implements IAuthAPI {
  AuthenticationAPI(this.baseUrl, this._client);

  final http.Client _client;
  String baseUrl;

  @override
  Future<Result<String>> signIn(SignInCredentials credentials) async {
    final String endpoint = '$baseUrl/auth/signin';
    return _submitRequest(endpoint, credentials);
  }

  @override
  Future<Result<String>> signUp(SignUpCredentials credentials) async {
    final String endpoint = '$baseUrl/auth/signup';
    return _submitRequest(endpoint, credentials);
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    final Uri url = Uri.parse('$baseUrl/auth/signout');
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

  Future<Result<String>> _submitRequest(
    String endpoint,
    dynamic credentials,
  ) async {
    final Uri uri = Uri.parse(endpoint);
    final http.Response response = await _client.post(
      uri,
      body: jsonEncode(Mapper.toJson(credentials)),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      final Map<String, dynamic> map =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Result<String>.error(_mapError(map));
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

  String _mapError(Map<String, dynamic> map) {
    final dynamic contents =
        map['error'] as dynamic ?? map['errors'] as dynamic;
    if (contents is String) {
      return contents;
    }
    final dynamic errorString = contents.fold(
      '',
      (dynamic prev, dynamic el) => '$prev${el.values.first}\n',
    );

    return errorString.toString().trim();
  }
}

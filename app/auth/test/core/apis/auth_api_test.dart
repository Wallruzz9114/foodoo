import 'dart:convert';

import 'package:async/async.dart';
import 'package:auth/src/authentication_api.dart';
import 'package:auth/src/models/objects/sign_in_credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_api_test.mocks.dart';

@GenerateMocks(<Type>[http.Client])
void main() {
  late MockClient client;
  late AuthenticationAPI api;

  setUp(() {
    client = MockClient();
    api = AuthenticationAPI('http:baseUrl', client);
  });

  group('signin', () {
    final SignInCredentials credentials = SignInCredentials(
      username: 'testuser',
      password: 'pass',
    );

    test('should return error when status code is not 200', () async {
      when(client.post(any, body: anyNamed('body'))).thenAnswer(
        (_) async => http.Response('{}', 404),
      );
      final Result<String> result = await api.signIn(credentials);
      expect(result, isA<ErrorResult>());
    });

    test('should return error when status code is 200 but malformed json',
        () async {
      when(client.post(any, body: anyNamed('body'))).thenAnswer(
        (_) async => http.Response('{}', 200),
      );
      final Result<String> result = await api.signIn(credentials);
      expect(result, isA<ErrorResult>());
    });

    test('should return token string when successful', () async {
      const String tokenStr = 'wg942vf9ubqvc..';
      when(client.post(any, body: anyNamed('body'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode(<String, dynamic>{'auth_token': tokenStr}),
          200,
        ),
      );
      final Result<String> result = await api.signIn(credentials);
      expect(result.asValue!.value, tokenStr);
    });
  });
}

import 'package:async/src/result/result.dart';
import 'package:auth/src/authentication_api.dart';
import 'package:auth/src/models/objects/sign_in_credentials.dart';
import 'package:auth/src/models/objects/sign_up_credentials.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  http.Client client;
  late AuthenticationAPI api;
  const String baseUrl = 'http://localhost:3000';

  setUp(() {
    client = http.Client();
    api = AuthenticationAPI(baseUrl, client);
  });

  final SignUpCredentials signUpcredentials = SignUpCredentials(
    username: 'sdgfreigne',
    email: 'oghuwr@email.com',
    password: 'P@ssw0rd123!',
  );

  final SignInCredentials signIncredentials = SignInCredentials(
    username: 'sdgfreigne',
    password: 'P@ssw0rd123!',
  );

  group('signup', () {
    test('should return json web token when successful', () async {
      final Result<String> result = await api.signUp(signUpcredentials);
      expect(result.asValue!.value, isNotEmpty);
    });
  });

  group('signin', () {
    test('should return json web token when successful', () async {
      final Result<String> result = await api.signIn(signIncredentials);
      expect(result.asValue!.value, isNotEmpty);
    });
  });

  group('signout', () {
    test('should sign out user and return true', () async {
      final Result<String> tokenString = await api.signIn(signIncredentials);
      final Token token = Token(value: tokenString.asValue!.value);
      final Result<bool> result = await api.signOut(token);
      expect(result.asValue!.value, true);
    });
  });
}

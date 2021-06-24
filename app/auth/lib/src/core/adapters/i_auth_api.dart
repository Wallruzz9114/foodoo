import 'package:async/async.dart';
import 'package:auth/src/models/objects/sign_in_credentials.dart';
import 'package:auth/src/models/objects/sign_up_credentials.dart';
import 'package:auth/src/models/objects/token.dart';

abstract class IAuthAPI {
  Future<Result<String>> signIn(SignInCredentials credentials);
  Future<Result<String>> signUp(SignUpCredentials credentials);
  Future<Result<bool>> signOut(Token token);
}

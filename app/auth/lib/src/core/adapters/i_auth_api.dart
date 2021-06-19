import 'package:async/async.dart';
import 'package:auth/src/models/objects/credentials.dart';
import 'package:auth/src/models/objects/token.dart';

abstract class IAuthAPI {
  Future<Result<String>> signIn(Credentials credentials);
  Future<Result<String>> signUp(Credentials credentials);
  Future<Result<bool>> signOut(Token token);
}

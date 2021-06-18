import 'package:async/async.dart';
import 'package:auth/src/models/objects/credentials.dart';

abstract class IAuthAPI {
  Future<Result<String>> signIn(Credentials credentials);
  Future<Result<String>> signUp(Credentials credentials);
  Future<void> signOut();
}

import 'package:async/async.dart';
import 'package:auth/src/models/objects/token.dart';

abstract class IAuthService {
  Future<Result<Token>> signUp(String username, String email, String password);
  Future<Result<Token>> signIn();
  Future<void> signOut();
}

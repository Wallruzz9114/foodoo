import 'package:auth/src/models/objects/token.dart';

abstract class IAuthService {
  Future<dynamic> signUp(String username, String email, String password);
  Future<dynamic> signIn();
  Future<dynamic> signOut(Token token);
}

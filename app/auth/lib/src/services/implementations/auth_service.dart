import 'package:async/async.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';

class AuthService {
  AuthService(this._authService);

  final IAuthService _authService;

  Future<Result<Token>> signIn() async {
    return _authService.signIn();
  }

  Future<Result<Token>> signUp(
    String username,
    String email,
    String password,
  ) async {
    return _authService.signUp(username, email, password);
  }

  Future<void> signOut() async {}
}

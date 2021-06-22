import 'package:async/async.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';

class SignUpUsecase {
  SignUpUsecase(this._authService);

  final IAuthService _authService;

  Future<Result<Token>> execute(
    String username,
    String email,
    String password,
  ) async {
    return _authService.signUp(username, email, password);
  }
}

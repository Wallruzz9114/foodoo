import 'package:async/async.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';

class SignOutUsecase {
  SignOutUsecase(this._authService);

  final IAuthService _authService;

  Future<Result<bool>> execute(Token token) {
    return _authService.signOut(token);
  }
}

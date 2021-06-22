import 'package:auth/src/models/objects/token.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';
import 'package:async/async.dart';

class SignInUsecase {
  SignInUsecase(this._authService);

  final IAuthService _authService;

  Future<Result<Token>> execute() async {
    return _authService.signIn();
  }
}

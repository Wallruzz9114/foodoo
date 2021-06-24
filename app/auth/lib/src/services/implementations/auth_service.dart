import 'package:async/async.dart';
import 'package:auth/src/core/adapters/i_auth_api.dart';
import 'package:auth/src/models/objects/sign_in_credentials.dart';
import 'package:auth/src/models/objects/sign_up_credentials.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';

class AuthService implements IAuthService {
  AuthService(this._authAPI);

  final IAuthAPI _authAPI;
  late dynamic _credentials;

  void setSignInSignUpCredentials({
    required String username,
    required String password,
  }) {
    _credentials = SignInCredentials(
      username: username,
      password: password,
    );
  }

  @override
  Future<dynamic> signIn() async {
    assert(_credentials != null);
    final Result<String> result =
        await _authAPI.signIn(_credentials as SignInCredentials);
    if (result.isError) {
      return result.asError;
    }
    return Result<Token>.value(Token(value: result.asValue!.value));
  }

  @override
  Future<dynamic> signUp(
    String username,
    String email,
    String password,
  ) async {
    _credentials = SignUpCredentials(
      username: username,
      email: email,
      password: password,
    );
    final Result<String> result =
        await _authAPI.signUp(_credentials as SignUpCredentials);
    if (result.isError) {
      return result.asError;
    }
    return Result<Token>.value(Token(value: result.asValue!.value));
  }

  @override
  Future<Result<dynamic>> signOut(Token token) async {
    return _authAPI.signOut(token);
  }
}

import 'package:async/async.dart';
import 'package:auth/src/core/adapters/i_auth_api.dart';
import 'package:auth/src/models/objects/sign_in_credentials.dart';
import 'package:auth/src/models/objects/sign_up_credentials.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';

class AuthAPI implements IAuthService {
  AuthAPI(this._api);

  final IAuthAPI _api;
  late SignInCredentials _signInCredentials;

  void createSignInSignUpCredentials({
    required String username,
    required String password,
  }) {
    _signInCredentials = SignInCredentials(
      username: username,
      password: password,
    );
  }

  @override
  Future<Result<Token>> signIn() async {
    assert(_signInCredentials != null);
    final Result<String> result = await _api.signIn(_signInCredentials);

    if (result.isError) {
      return result.asError! as Future<Result<Token>>;
    }

    return Result<Token>.value(Token(value: result.asValue!.value));
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    return _api.signOut(token);
  }

  @override
  Future<Result<Token>> signUp(
    String username,
    String email,
    String password,
  ) async {
    final SignUpCredentials credentials = SignUpCredentials(
      username: username,
      email: email,
      password: password,
    );

    final Result<String> result = await _api.signUp(credentials);

    if (result.isError) {
      return result.asError! as Future<Result<Token>>;
    }

    return Result<Token>.value(Token(value: result.asValue!.value));
  }
}

import 'package:async/async.dart';
import 'package:auth/src/core/adapters/i_auth_api.dart';
import 'package:auth/src/models/objects/credentials.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';

class AuthService implements IAuthService {
  AuthService(this._authAPI);

  final IAuthAPI _authAPI;
  late Credentials _credentials;

  void setSignInCredentials({
    required String username,
    required String password,
  }) {
    _credentials = Credentials(
      username: username,
      password: password,
    );
  }

  @override
  Future<Result<Token>> signIn() async {
    assert(_credentials != null);
    final Result<String> result = await _authAPI.signIn(_credentials);
    if (result.isError) {
      return Result<Token>.value(Token(value: result.asError!.error as String));
    }
    return Result<Token>.value(Token(value: result.asValue!.value));
  }

  @override
  Future<Result<Token>> signUp(
    String username,
    String email,
    String password,
  ) async {
    _credentials = Credentials(
      username: username,
      email: email,
      password: password,
    );
    final Result<String> result = await _authAPI.signIn(_credentials);
    if (result.isError) {
      return Result<Token>.value(Token(value: result.asError!.error as String));
    }
    return Result<Token>.value(Token(value: result.asValue!.value));
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    return _authAPI.signOut(token);
  }
}

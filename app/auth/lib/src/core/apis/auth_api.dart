import 'package:async/async.dart';
import 'package:auth/src/core/adapters/i_auth_api.dart';
import 'package:auth/src/models/objects/credentials.dart';
import 'package:auth/src/models/objects/token.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';

class AuthAPI implements IAuthService {
  AuthAPI(this._api);

  final IAuthAPI _api;
  late Credentials _credentials;

  void createCredentials({
    String? username,
    required String email,
    required String password,
  }) {
    _credentials = Credentials(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Future<Result<Token>> signIn() async {
    assert(_credentials != null);
    final Result<String> result = await _api.signIn(_credentials);

    if (result.isError) {
      return result.asError! as Future<Result<Token>>;
    }

    return Result<Token>.value(Token(value: result.asValue!.value));
  }

  @override
  Future<void> signOut() async {
    throw UnimplementedError();
  }

  @override
  Future<Result<Token>> signUp(
    String username,
    String email,
    String password,
  ) async {
    final Credentials credentials = Credentials(
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

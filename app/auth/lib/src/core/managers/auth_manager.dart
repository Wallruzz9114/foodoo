import 'package:auth/src/core/adapters/i_auth_api.dart';
import 'package:auth/src/services/implementations/auth_service.dart';
import 'package:auth/src/services/interfaces/i_auth_service_.dart';

class AuthManager {
  AuthManager(IAuthAPI authAPI) {
    _authAPI = authAPI;
  }

  late IAuthAPI _authAPI;

  IAuthService signInManager({
    required String username,
    required String password,
  }) {
    final AuthService authAPI = AuthService(_authAPI);
    authAPI.setSignInSignUpCredentials(username: username, password: password);
    return authAPI;
  }
}

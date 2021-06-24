import 'package:auth/src/models/objects/sign_in_credentials.dart';
import 'package:auth/src/models/objects/sign_up_credentials.dart';

class Mapper {
  static Map<String, dynamic> toJson(dynamic credentials) =>
      credentials is SignUpCredentials
          ? <String, dynamic>{
              'username': credentials.username,
              'email': credentials.email,
              'password': credentials.password
            }
          : credentials is SignInCredentials
              ? <String, dynamic>{
                  'username': credentials.username,
                  'password': credentials.password
                }
              : <String, dynamic>{};
}

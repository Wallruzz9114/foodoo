import 'package:auth/src/models/objects/credentials.dart';

class Mapper {
  static Map<String, dynamic> toJson(Credentials credentials) =>
      <String, dynamic>{
        'username': credentials.username,
        'email': credentials.email,
        'password': credentials.password
      };
}

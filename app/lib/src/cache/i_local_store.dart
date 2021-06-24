import 'package:auth/auth.dart';

abstract class ILocalStore {
  Future<Token> fetch();
  void delete(Token token);
  Future<void> save(Token token);
}

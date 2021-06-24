import 'package:auth/auth.dart';
import 'package:foodoo/src/cache/i_local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String CACHED_TOKEN = 'cached_token';

class LocalStore implements ILocalStore {
  LocalStore(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<Token> fetch() {
    final Object? tokenString = sharedPreferences.get(CACHED_TOKEN);

    if (tokenString != null) {
      return Future<Token>.value(Token(value: tokenString.toString()));
    }

    return Future<Token>.value(const Token(value: ''));
  }

  @override
  void delete(Token token) {
    sharedPreferences.remove(CACHED_TOKEN);
  }

  @override
  Future<void> save(Token token) {
    return sharedPreferences.setString(CACHED_TOKEN, token.value);
  }
}

import 'package:auth/auth.dart';
import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/src/cache/i_local_store.dart';
import 'package:foodoo/src/models/user.dart';
import 'package:foodoo/src/state/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.localStore) : super(AuthInitialState());

  final ILocalStore localStore;

  Future<void> signUp(IAuthService authService, User user) async {
    _startLoading();
    final Result<Token> result = await authService.signUp(
      user.username,
      user.email,
      user.password,
    );
    _setResultOfAuthState(result);
  }

  Future<void> signIn(IAuthService authService) async {
    _startLoading();
    final Result<Token> result = await authService.signIn();
    _setResultOfAuthState(result);
  }

  Future<void> signOut(IAuthService authService) async {
    _startLoading();
    final Token token = await localStore.fetch();
    final Result<bool> result = await authService.signOut(token);

    if (result.asValue!.value) {
      localStore.delete(token);
      emit(SignOutSuccessState());
    } else {
      emit(AuthErrorState('Error signing out'));
    }
  }

  void _startLoading() {
    emit(AuthLoadingState());
  }

  void _setResultOfAuthState(Result<Token> result) {
    if (result.asError != null) {
      emit(AuthErrorState(result.asError!.error as String));
      return;
    }
    emit(AuthErrorState(result.asValue!.value as String));
  }
}

import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object?> get props => <Object>[];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object?> get props => <Object>[];
}

class AuthSuccessState extends AuthState {
  AuthSuccessState(this.token);

  final Token token;

  @override
  List<Object?> get props => <Object>[];
}

class AuthErrorState extends AuthState {
  AuthErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => <Object>[];
}

class SignOutSuccessState extends AuthState {
  @override
  List<Object?> get props => <Object>[];
}

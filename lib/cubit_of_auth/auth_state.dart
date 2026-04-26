import '../model_of_login/login_reponse.dart';

abstract class AuthState{

}

class InitialAuthState extends AuthState{}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final LoginResponse data;
  AuthSuccess(this.data);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
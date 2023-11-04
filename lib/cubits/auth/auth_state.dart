import 'package:insta_chat/model/user_model.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

class SignInLoadingState extends AuthState {}

class SignInSuccessState extends AuthState {
  final String uid;
  SignInSuccessState({required this.uid});
}

class SignInErrorState extends AuthState {
  final String error;

  SignInErrorState(this.error);
}

class ChangePasswordState extends AuthState {}

class LoadingState extends AuthState {}

class PhoneAuthErrorState extends AuthState {
  final String messageError;

  PhoneAuthErrorState({required this.messageError});
}

class PhoneNumberSubmittedState extends AuthState {}

class PhoneOTPVerifiedState extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {}

class LoginErrorState extends AuthState {
  final String messageError;

  LoginErrorState({required this.messageError});
}

class ChangeValueSuccessState extends AuthState {}

class SignUpLoadingState extends AuthState {}

class CreateUserAccountLoadingState extends AuthState {}

class SignUpSuccessState extends AuthState {
  final UserModel userModel;

  SignUpSuccessState({required this.userModel});
}

class CreateUserAccountState extends AuthState {
  final UserModel userModel;

  CreateUserAccountState({required this.userModel});
}

class CreateUserAccountErrorState extends AuthState {
  final String error;

  CreateUserAccountErrorState({required this.error});
}

class SignUpErrorState extends AuthState {
  final String error;

  SignUpErrorState({required this.error});
}

class EmailVerificationInitialState extends AuthState {}

class SendVerificationLoadingState extends AuthState {}

class SendVerificationSuccessState extends AuthState {}

class SendVerificationErrorState extends AuthState {
  final String? errorString;
  SendVerificationErrorState(this.errorString);
}

class ReloadLoadingState extends AuthState {}

class ReloadSuccessState extends AuthState {}

class ReloadErrorState extends AuthState {
  final String? errorString;
  ReloadErrorState(this.errorString);
}

class EmailVerifiedSuccessfullyState extends AuthState {}

class ResetPasswordLoadingState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {}

class ResetPasswordErrorState extends AuthState {
  final String error;
  ResetPasswordErrorState({required this.error});
}

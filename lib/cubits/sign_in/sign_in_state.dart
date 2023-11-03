abstract class SignInState {}

class SignInInitialState extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {
  final String uid;
  SignInSuccessState({required this.uid});
}

class SignInErrorState extends SignInState {
  final String error;

  SignInErrorState(this.error);
}

class ChangePasswordState extends SignInState {}

class LoadingState extends SignInState {}

class PhoneAuthErrorState extends SignInState {
  final String messageError;

  PhoneAuthErrorState({required this.messageError});
}

class PhoneNumberSubmittedState extends SignInState {}

class PhoneOTPVerifiedState extends SignInState {}

class LoginLoadingState extends SignInState {}

class LoginSuccessState extends SignInState {}

class LoginErrorState extends SignInState {
  final String messageError;

  LoginErrorState({required this.messageError});
}

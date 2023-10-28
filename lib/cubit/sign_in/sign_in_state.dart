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

import 'package:insta_chat/model/user_model.dart';

abstract class SignUpState {}

class SignUpInitialState extends SignUpState {}

class ChangePasswordState extends SignUpState {}

class ChangeValueSuccessState extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class CreateUserAccountLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {
  final UserModel userModel;

  SignUpSuccessState({required this.userModel});
}

class CreateUserAccountState extends SignUpState {
  final UserModel userModel;

  CreateUserAccountState({required this.userModel});
}

class CreateUserAccountErrorState extends SignUpState {
  final String error;

  CreateUserAccountErrorState({required this.error});
}

class SignUpErrorState extends SignUpState {
  final String error;

  SignUpErrorState({required this.error});
}

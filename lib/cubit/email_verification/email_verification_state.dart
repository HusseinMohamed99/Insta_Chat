part of 'email_verification_cubit.dart';

@immutable
sealed class EmailVerificationState {}

class EmailVerificationInitialState extends EmailVerificationState {}

class SendVerificationLoadingState extends EmailVerificationState {}

class SendVerificationSuccessState extends EmailVerificationState {}

class SendVerificationErrorState extends EmailVerificationState {
  final String? errorString;
  SendVerificationErrorState(this.errorString);
}

class ReloadLoadingState extends EmailVerificationState {}

class ReloadSuccessState extends EmailVerificationState {}

class ReloadErrorState extends EmailVerificationState {
  final String? errorString;
  ReloadErrorState(this.errorString);
}

class EmailVerifiedSuccessfullyState extends EmailVerificationState {}

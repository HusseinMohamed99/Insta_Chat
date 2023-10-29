abstract class MainState {}

class MainInitial extends MainState {}

class GetUserDataLoadingState extends MainState {}

class GetUserDataSuccessState extends MainState {}

class GetUserDataErrorState extends MainState {
  final String error;
  GetUserDataErrorState({required this.error});
}

class GetAllUsersLoadingState extends MainState {}

class GetAllUsersSuccessState extends MainState {}

class GetAllUsersErrorState extends MainState {
  final String error;
  GetAllUsersErrorState({required this.error});
}

class SetUSerTokenLoadingState extends MainState {}

class SetUSerTokenSuccessState extends MainState {}

class GetProfileImagePickedSuccessState extends MainState {}

class GetProfileImagePickedErrorState extends MainState {}

class UpdateUserLoadingState extends MainState {}

class UploadProfileImageErrorState extends MainState {}

class UpdateUserSuccessState extends MainState {}

class UpdateUserErrorState extends MainState {}

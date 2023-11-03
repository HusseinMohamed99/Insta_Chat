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

class SendMessageSuccessState extends MainState {}

class SendMessageErrorState extends MainState {}

class GetMessageSuccessState extends MainState {}

class MessageImagePickedSuccessState extends MainState {}

class MessageImagePickedErrorState extends MainState {}

class DeleteMessageImageSuccessState extends MainState {}

class UploadMessageImageLoadingState extends MainState {}

class UploadMessageImageErrorState extends MainState {}

class SendFCMNotificationSuccessState extends MainState {}

class SendInAppNotificationLoadingState extends MainState {}

class SetNotificationIdSuccessState extends MainState {}

class ChangeUserPasswordLoadingState extends MainState {}

class ChangeUserPasswordSuccessState extends MainState {}

class ChangeUserPasswordErrorState extends MainState {
  final String error;
  ChangeUserPasswordErrorState({required this.error});
}

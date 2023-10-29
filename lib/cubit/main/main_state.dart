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

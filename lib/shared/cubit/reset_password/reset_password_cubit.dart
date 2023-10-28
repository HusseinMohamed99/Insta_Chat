import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/shared/cubit/reset_password/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());
  static ResetPasswordCubit get(context) => BlocProvider.of(context);
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/model/user_model.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:meta/meta.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit() : super(EmailVerificationInitialState());
  static EmailVerificationCubit get(context) => BlocProvider.of(context);
  bool isEmailSent = false;
  void sendEmailVerification() {
    emit(SendVerificationLoadingState());
    FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
      isEmailSent = true;
      emit(SendVerificationSuccessState());
    }).catchError((error) {
      emit(SendVerificationErrorState(error.toString()));
    });
  }

  bool isEmailVerified = false;
  UserModel? userModel;
  Future<void> reloadUser() async {
    emit(ReloadLoadingState());
    await FirebaseAuth.instance.currentUser!.reload().then((value) {
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        isEmailVerified = true;
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .update({'isEmailVerified': true}).then(
                (value) => emit(EmailVerifiedSuccessfullyState()));
      }
      print(isEmailVerified);
      emit(ReloadSuccessState());
    }).catchError((error) {
      emit(ReloadErrorState(error.toString()));
    });
  }
}

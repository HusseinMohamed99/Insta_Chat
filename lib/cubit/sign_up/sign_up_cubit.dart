import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/sign_up/sign_up_state.dart';
import 'package:insta_chat/model/user_model.dart';
import 'package:insta_chat/shared/network/cache_helper.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePassword() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordState());
  }

  bool isCheck = false;

  void boxCheck(bool newCheck) async {
    if (isCheck == newCheck) return;
    isCheck = newCheck;
    CacheHelper.saveData(key: 'check', value: isCheck).then((value) {
      emit(ChangeValueSuccessState());
      if (kDebugMode) {
        print('isCheck === $isCheck');
      }
    });
  }

  UserModel? userModel;
  void userSignUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreateAccount(
          email: email, phone: phone, name: name, uid: value.user!.uid);
    }).catchError((error) {
      emit(SignUpErrorState(error: error.toString()));
    });
  }

  void userCreateAccount({
    required String name,
    required String email,
    required String uid,
    required String phone,
  }) async {
    UserModel userModel = UserModel(
      name: name,
      email: email,
      phone: phone,
      uid: uid,
      image:
          'https://firebasestorage.googleapis.com/v0/b/insta-chat-e6467.appspot.com/o/avatar.svg?alt=media&token=7262ad31-dc1b-416e-b5d9-0f3679643b38',
      bio: 'Write a bio...',
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toMap())
        .then((value) {
      emit(SignUpSuccessState(userModel: userModel));
    }).catchError((error) {
      emit(CreateUserAccountErrorState(error: error.toString()));
    });
  }
}

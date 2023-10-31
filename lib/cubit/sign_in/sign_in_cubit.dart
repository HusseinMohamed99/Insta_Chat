import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/sign_in/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitialState());

  static SignInCubit get(context) => BlocProvider.of(context);

  Future<void> userSignIn({
    required String email,
    required String password,
  }) async {
    emit(SignInLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(SignInSuccessState(uid: value.user!.uid));
    }).catchError((error) {
      emit(SignInErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePassword() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordState());
  }

  late String verificationId;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(LoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException error) {
    emit(PhoneAuthErrorState(messageError: error.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    emit(PhoneNumberSubmittedState());
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);
    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOTPVerifiedState());
    } catch (error) {
      emit(PhoneAuthErrorState(messageError: error.toString()));
    }
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String uid,
    required String phone,
    String? image,
    String? bio,
    bool? isEmailVerified,
  }) async {
    emit(LoginLoadingState());

    return await users.add({
      name: name,
      email: email,
      phone: phone,
      uid: uid,
      image:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1698676472~exp=1698677072~hmac=cc82479ff1f2ca3e7720bfb52c550620688b05d13f93a4f5167ae88ca619eab9',
      bio: 'Write a bio...',
      isEmailVerified: false,
    }).then((value) {
      emit(LoginSuccessState());
    }).catchError((error) {
      emit(LoginErrorState(messageError: error));
    });
  }
}

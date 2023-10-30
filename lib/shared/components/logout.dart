import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/network/cache_helper.dart';
import 'package:insta_chat/view/signIn/sign_in_view.dart';

void logOut({required buildContext}) {
  CacheHelper.removeData(
    key: 'uId',
  ).then((value) {
    if (value) {
      FirebaseAuth.instance.signOut();
      navigateAndFinish(buildContext, const SignInScreen());
    }
  });
}

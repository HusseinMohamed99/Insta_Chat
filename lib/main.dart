import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/email_verification/email_verification_cubit.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/cubit/reset_password/reset_password_cubit.dart';
import 'package:insta_chat/cubit/sign_in/sign_in_cubit.dart';
import 'package:insta_chat/cubit/sign_up/sign_up_cubit.dart';
import 'package:insta_chat/firebase_options.dart';
import 'package:insta_chat/shared/bloc_observer.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/shared/network/cache_helper.dart';
import 'package:insta_chat/shared/network/dio_helper.dart';
import 'package:insta_chat/utils/themes.dart';
import 'package:insta_chat/view/onBoard/on_board_view.dart';
import 'package:insta_chat/view/signIn/sign_in_view.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showToast(text: 'You Received Message', state: ToastStates.success);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('authorizationStatus: ${settings.authorizationStatus}');
  }
  //when the app is opened
  FirebaseMessaging.onMessage.listen((event) {
    showToast(text: 'You Received Message', state: ToastStates.success);
  });
  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast(text: 'openedApp', state: ToastStates.success);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  uId = CacheHelper.getData(key: 'uId');

  Widget widget;
  if (uId != null) {
    widget = const OnBoardScreen();
  } else {
    widget = const SignInScreen();
  }
  print(uId);
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget});
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          if (uId != null) {
            return MainCubit()
              ..getUserData()
              ..getAllUsers();
          } else {
            return MainCubit()..getAllUsers();
          }
        }),
        BlocProvider(
          create: (context) => SignUpCubit(),
        ),
        BlocProvider(
          create: (context) => SignInCubit(),
        ),
        BlocProvider(
          create: (context) => ResetPasswordCubit(),
        ),
        BlocProvider(
          create: (context) => EmailVerificationCubit(),
        ),
      ],
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Insta Chat',
            debugShowCheckedModeBanner: false,
            theme: getApplicationTheme(),
            home: startWidget,
          );
        },
      ),
    );
  }
}

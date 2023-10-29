import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/cubit/reset_password/reset_password_cubit.dart';
import 'package:insta_chat/cubit/sign_in/sign_in_cubit.dart';
import 'package:insta_chat/cubit/sign_up/sign_up_cubit.dart';
import 'package:insta_chat/firebase_options.dart';
import 'package:insta_chat/shared/bloc_observer.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/shared/network/cache_helper.dart';
import 'package:insta_chat/shared/network/dio_helper.dart';
import 'package:insta_chat/utils/themes.dart';
import 'package:insta_chat/view/onBoard/on_board_view.dart';
import 'package:insta_chat/view/signIn/sign_in_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      ],
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Insta Chat',
            debugShowCheckedModeBanner: false,
            theme: getApplicationTheme(),
            home: uId == null ? const SignInScreen() : const OnBoardScreen(),
          );
        },
      ),
    );
  }
}

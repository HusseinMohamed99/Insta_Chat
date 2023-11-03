import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insta_chat/bloc_observer.dart';
import 'package:insta_chat/cubits/email_verification/email_verification_cubit.dart';
import 'package:insta_chat/cubits/main/main_cubit.dart';
import 'package:insta_chat/cubits/main/main_state.dart';
import 'package:insta_chat/cubits/reset_password/reset_password_cubit.dart';
import 'package:insta_chat/cubits/sign_in/sign_in_cubit.dart';
import 'package:insta_chat/cubits/sign_up/sign_up_cubit.dart';
import 'package:insta_chat/firebase_options.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/shared/network/cache_helper.dart';
import 'package:insta_chat/shared/network/dio_helper.dart';
import 'package:insta_chat/utils/themes.dart';
import 'package:insta_chat/view/signIn/sign_in_view.dart';
import 'package:insta_chat/view/welcome/welcome_view.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  showToast(text: 'You Received Message', state: ToastStates.success);
  print("Handling a background message: ${message.messageId}");
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: true,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );
  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }
  //when the app is closed
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  //when the app is opened
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showToast(text: 'You Received Message', state: ToastStates.success);
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast(text: 'opened App', state: ToastStates.success);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  getFcmToken();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  uId = CacheHelper.getData(key: 'uId');

  Widget widget;
  if (uId != null) {
    widget = const WelcomeScreen();
  } else {
    widget = const SignInScreen();
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}

Future<String?> getFcmToken() async {
  String? token = await messaging.getToken();
  print('Token id:$token');
  return token;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget});
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            if (uId != null) {
              return MainCubit()
                ..getUserData()
                ..getAllUsers();
            } else {
              return MainCubit()..getAllUsers();
            }
          },
        ),
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

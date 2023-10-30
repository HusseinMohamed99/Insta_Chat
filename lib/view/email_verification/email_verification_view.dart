import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/email_verification/email_verification_cubit.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/indicator.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/onBoard/on_board_view.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        if (state is ReloadSuccessState) {
          showToast(
            text: 'createAccountSuccessfully',
            state: ToastStates.success,
          );
          MainCubit.get(context).getUserData();
          MainCubit.get(context).getAllUsers();
        }
        if (state is ReloadErrorState) {
          showToast(
            text: state.errorString!,
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        EmailVerificationCubit cubit = EmailVerificationCubit.get(context);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          child: Scaffold(
            body: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * .1),
                    CircleAvatar(
                      radius: 83,
                      backgroundColor: ColorManager.error,
                      child: const CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage(Assets.imagesEmail),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'emailConfirmation',
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "We're happy you signed up for Socialite. To start exploring the Socialite,Please confirm your\nE-mail Address.",
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 45),
                    state is SendVerificationLoadingState
                        ? const AdaptiveIndicator()
                        : cubit.isEmailSent
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 250,
                                    height: 40,
                                    color: ColorManager.success,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: ColorManager.black,
                                        ),
                                        Text(
                                          'emailVerification',
                                          style: textTheme.headlineSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: ColorManager.white,
                                    ),
                                    onPressed: () {
                                      cubit.sendEmailVerification();
                                    },
                                    child: Text(
                                      'sendAgain',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                color: ColorManager.primaryColor,
                                child: defaultTextButton(
                                  context: context,
                                  function: () {
                                    cubit.sendEmailVerification();
                                  },
                                  text: 'sendEmail',
                                ),
                              ),
                    const SizedBox(height: 15),
                    cubit.isEmailSent
                        ? Container(
                            color: ColorManager.success,
                            child: defaultTextButton(
                              context: context,
                              function: () {
                                cubit.reloadUser().then(
                                  (value) {
                                    if (cubit.isEmailVerified) {
                                      MainCubit.get(context)
                                        ..getUserData()
                                        ..getAllUsers();

                                      navigateAndFinish(
                                        context,
                                        const OnBoardScreen(),
                                      );
                                    } else {}
                                  },
                                );
                              },
                              text: 'verified',
                            ),
                          )
                        : Container(
                            color: ColorManager.white,
                            child: defaultTextButton(
                              context: context,
                              function: () {},
                              text: 'verified',
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

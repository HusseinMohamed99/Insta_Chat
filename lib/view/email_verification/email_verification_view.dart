import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/email_verification/email_verification_cubit.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/signIn/sign_in_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
            text: 'create Account Successfully',
            state: ToastStates.success,
          );
          MainCubit.get(context).getUserData();
          MainCubit.get(context).getAllUsers();
        } else {
          showToast(
            text: 'Please Verify Your Email',
            state: ToastStates.error,
          );
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
          child: ModalProgressHUD(
            inAsyncCall: state is SendVerificationLoadingState,
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
                      const SizedBox(height: AppSize.s16),
                      Text(
                        'Email Confirmation',
                        style: textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSize.s10),
                      Text(
                        "We're happy you signed up for Socialite. To start exploring the Socialite,Please confirm your\nE-mail Address.",
                        style: textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSize.s40),
                      cubit.isEmailSent
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: AppSize.s250,
                                  height: AppSize.s40,
                                  decoration: BoxDecoration(
                                    color: ColorManager.success,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: ColorManager.black,
                                      ),
                                      Text(
                                        'Email Verification',
                                        style: textTheme.headlineSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppSize.s16),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: ColorManager.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    cubit.sendEmailVerification();
                                  },
                                  child: Text(
                                    'Send Again',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: defaultTextButton(
                                context: context,
                                function: () {
                                  cubit.sendEmailVerification();
                                },
                                text: 'Send Email',
                              ),
                            ),
                      const SizedBox(height: AppSize.s16),
                      cubit.isEmailSent
                          ? Container(
                              decoration: BoxDecoration(
                                color: ColorManager.success,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: defaultTextButton(
                                context: context,
                                function: () {
                                  cubit.reloadUser().then(
                                    (value) {
                                      if (cubit.isEmailVerified) {
                                        navigateAndFinish(
                                          context,
                                          const SignInScreen(),
                                        );
                                      } else {}
                                    },
                                  );
                                },
                                text: 'Verified',
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(AppPadding.p12),
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Verified',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

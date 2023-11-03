import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/reset_password/reset_password_cubit.dart';
import 'package:insta_chat/cubit/reset_password/reset_password_state.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/shared/components/text_form_field.dart';
import 'package:insta_chat/utils/app_string.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/my_validators.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/signIn/sign_in_view.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final FocusNode emailFocusNode = FocusNode();

    return BlocConsumer<ResetPasswordCubit, ResetPasswordStates>(
      listener: (context, state) {
        if (state is ResetPasswordSuccessState) {
          showToast(
              text: 'Reset Password Successfully', state: ToastStates.success);
          navigateAndFinish(context, const SignInScreen());
        }
        if (state is ResetPasswordErrorState) {
          showToast(text: state.error, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final ResetPasswordCubit resetPasswordCubit =
            ResetPasswordCubit.get(context);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
              title: Text(
                AppString.forgotPassword,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 28, left: 40, right: 40, bottom: 54),
                  child: Text(
                    AppString.forgotPasswordHint,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p40,
                      vertical: AppPadding.p60,
                    ),
                    width: screenWidth,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                    ),
                    child: Form(
                      key: formKey,
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        slivers: [
                          SliverToBoxAdapter(
                            child: CustomTextFormField(
                              prefixIcon: Icons.email_outlined,
                              controller: emailController,
                              focusNode: emailFocusNode,
                              textInputAction: TextInputAction.next,
                              hintText: AppString.email,
                              textInputType: TextInputType.emailAddress,
                              validator: (value) {
                                return MyValidators.emailValidator(value);
                              },
                              onFieldSubmitted: (value) {},
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: screenHeight * .15,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: defaultMaterialButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  resetPasswordCubit.resetPassword(
                                    email: emailController.text,
                                  );
                                }
                              },
                              text: AppString.resetPassword,
                              context: context,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

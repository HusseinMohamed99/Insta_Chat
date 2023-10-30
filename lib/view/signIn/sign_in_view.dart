import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/sign_in/sign_in_cubit.dart';
import 'package:insta_chat/cubit/sign_in/sign_in_state.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/shared/components/text_form_field.dart';
import 'package:insta_chat/shared/network/cache_helper.dart';
import 'package:insta_chat/utils/app_string.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/my_validators.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/onBoard/on_board_view.dart';
import 'package:insta_chat/view/signUp/sign_up_view.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode passwordFocusNode = FocusNode();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final SignInCubit signInCubit = SignInCubit.get(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccessState) {
            CacheHelper.saveData(value: state.uid, key: 'uId');
            showToast(text: 'Sign In Successfully', state: ToastStates.success);
            uId = state.uid;
            navigateAndFinish(context, const OnBoardScreen());
          }

          if (state is SignInErrorState) {
            showToast(text: state.error, state: ToastStates.error);
          }
        },
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                ),
                title: Text(
                  AppString.signIn,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 28, left: 40, right: 40, bottom: 54),
                    child: Text(
                      AppString.signInHint,
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
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(passwordFocusNode);
                                },
                              ),
                            ),
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 28)),
                            SliverToBoxAdapter(
                              child: CustomTextFormField(
                                controller: passwordController,
                                focusNode: passwordFocusNode,
                                textInputType: TextInputType.visiblePassword,
                                prefixIcon: Icons.key,
                                suffixIcon: signInCubit.suffix,
                                obscureText: signInCubit.isPassword,
                                suffixIconOnTap: () {
                                  signInCubit.changePassword();
                                },
                                validator: (value) {
                                  return MyValidators.passwordValidator(value);
                                },
                                hintText: AppString.password,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {},
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: defaultTextButton(
                                  function: () {
                                    // navigateTo(context, const ResetPasswordScreen());
                                  },
                                  text: '${AppString.forgotPassword}?',
                                  context: context,
                                  color: ColorManager.primaryColor,
                                  fontSize: 14,
                                ),
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
                                    signInCubit.userSignIn(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                text: AppString.signIn,
                                context: context,
                                color: ColorManager.primaryColor,
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 28,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppString.noAccount,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  defaultTextButton(
                                    function: () {
                                      navigateTo(context, const SignUpScreen());
                                    },
                                    text: AppString.signUp,
                                    context: context,
                                    color: ColorManager.primaryColor,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: screenHeight * .05,
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
      ),
    );
  }
}

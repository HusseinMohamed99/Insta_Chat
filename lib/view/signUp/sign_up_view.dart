import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubits/auth/auth_cubit.dart';
import 'package:insta_chat/cubits/auth/auth_state.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/check_box.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/shared/components/text_form_field.dart';
import 'package:insta_chat/shared/network/cache_helper.dart';
import 'package:insta_chat/utils/app_string.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/my_validators.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/email_verification/email_verification_view.dart';
import 'package:insta_chat/view/signIn/sign_in_view.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final FocusNode nameFocusNode = FocusNode();
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode phoneFocusNode = FocusNode();
    final FocusNode passwordFocusNode = FocusNode();
    final FocusNode confirmPasswordFocusNode = FocusNode();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final AuthCubit signUpCubit = AuthCubit.get(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SignUpSuccessState) {
            CacheHelper.saveData(value: state.userModel.uid, key: 'uId');
            showToast(text: 'Sign Up Success', state: ToastStates.success);
            navigateAndFinish(
              context,
              const EmailVerificationScreen(),
            );
          }
          if (state is SignUpErrorState) {
            showToast(text: state.error, state: ToastStates.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
              title: Text(
                AppString.signUp,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 28,
                    left: 40,
                    right: 40,
                    bottom: 54,
                  ),
                  child: Text(
                    AppString.signUpHint,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: AppPadding.p40,
                      right: AppPadding.p40,
                      top: AppPadding.p60,
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
                        slivers: [
                          SliverToBoxAdapter(
                            child: CustomTextFormField(
                              prefixIcon: Icons.man_outlined,
                              controller: nameController,
                              focusNode: nameFocusNode,
                              textInputAction: TextInputAction.next,
                              hintText: AppString.name,
                              textInputType: TextInputType.name,
                              validator: (value) {
                                return MyValidators.displayNameValidator(value);
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(emailFocusNode);
                              },
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 28)),
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
                                    .requestFocus(phoneFocusNode);
                              },
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 28)),
                          SliverToBoxAdapter(
                            child: CustomTextFormField(
                              prefixIcon: Icons.phone_android_outlined,
                              controller: phoneController,
                              focusNode: phoneFocusNode,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.next,
                              hintText: AppString.phone,
                              textInputType: TextInputType.phone,
                              validator: (value) {
                                return MyValidators.phoneValidator(value);
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(passwordFocusNode);
                              },
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 28)),
                          SliverToBoxAdapter(
                            child: CustomTextFormField(
                              controller: passwordController,
                              focusNode: passwordFocusNode,
                              textInputType: TextInputType.visiblePassword,
                              prefixIcon: Icons.key,
                              suffixIcon: signUpCubit.suffix,
                              obscureText: signUpCubit.isPassword,
                              suffixIconOnTap: () {
                                signUpCubit.changePassword();
                              },
                              validator: (value) {
                                return MyValidators.passwordValidator(value);
                              },
                              hintText: AppString.password,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(confirmPasswordFocusNode);
                              },
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 28)),
                          SliverToBoxAdapter(
                            child: CustomTextFormField(
                              controller: confirmPasswordController,
                              focusNode: confirmPasswordFocusNode,
                              textInputType: TextInputType.visiblePassword,
                              prefixIcon: Icons.key,
                              suffixIcon: signUpCubit.suffix,
                              obscureText: signUpCubit.isPassword,
                              suffixIconOnTap: () {
                                signUpCubit.changePassword();
                              },
                              validator: (value) {
                                return MyValidators.repeatPasswordValidator(
                                  value: value,
                                  password: passwordController.text,
                                );
                              },
                              hintText: AppString.confirmPassword,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {},
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: screenHeight * .02,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                checkBox(
                                  context,
                                  color: ColorManager.grey,
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: AppString.agree,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          height: 0.2,
                                        ),
                                    children: [
                                      TextSpan(
                                        text: AppString.userPolicy,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              height: 0.2,
                                              color: ColorManager.primaryColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      TextSpan(
                                        text: ' & ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                      TextSpan(
                                        text: AppString.termUse,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              height: 0.2,
                                              color: ColorManager.primaryColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: screenHeight * .02,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: !signUpCubit.isCheck
                                ? defaultMaterialButton(
                                    function: () {},
                                    text: AppString.signUp,
                                    context: context,
                                    color: ColorManager.primaryColor
                                        .withOpacity(0.5),
                                  )
                                : defaultMaterialButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        signUpCubit.userSignUp(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          phone: phoneController.text,
                                        );
                                      }
                                    },
                                    text: AppString.signUp,
                                    context: context,
                                    color: ColorManager.primaryColor,
                                  ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 10,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppString.haveAccount,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                defaultTextButton(
                                  function: () {
                                    navigateTo(context, const SignInScreen());
                                  },
                                  text: AppString.signIn,
                                  context: context,
                                  color: ColorManager.primaryColor,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/shared/components/text_form_field.dart';
import 'package:insta_chat/utils/app_string.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/my_validators.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/password/instructions_password.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController oldPasswordController = TextEditingController();
    final FocusNode oldPasswordFocusNode = FocusNode();
    final TextEditingController newPasswordController = TextEditingController();
    final FocusNode newPasswordFocusNode = FocusNode();
    final TextEditingController confirmNewPasswordController =
        TextEditingController();
    final FocusNode confirmNewPasswordFocusNode = FocusNode();

    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is ChangeUserPasswordSuccessState) {
          showToast(
              text: 'Change Password Successfully', state: ToastStates.success);
          pop(context);
        }
        if (state is ChangeUserPasswordErrorState) {
          showToast(text: state.error, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final MainCubit mainCubit = MainCubit.get(context);
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
                AppString.changePassword,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            body: Column(
              children: [
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
                    child: ChangePasswordBody(
                      formKey: formKey,
                      oldPasswordController: oldPasswordController,
                      oldPasswordFocusNode: oldPasswordFocusNode,
                      newPasswordController: newPasswordController,
                      newPasswordFocusNode: newPasswordFocusNode,
                      confirmNewPasswordController:
                          confirmNewPasswordController,
                      confirmNewPasswordFocusNode: confirmNewPasswordFocusNode,
                      screenHeight: screenHeight,
                      mainCubit: mainCubit,
                      screenWidth: screenWidth,
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

class ChangePasswordBody extends StatelessWidget {
  const ChangePasswordBody({
    super.key,
    required this.formKey,
    required this.oldPasswordController,
    required this.oldPasswordFocusNode,
    required this.newPasswordController,
    required this.newPasswordFocusNode,
    required this.confirmNewPasswordController,
    required this.confirmNewPasswordFocusNode,
    required this.screenHeight,
    required this.screenWidth,
    required this.mainCubit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController oldPasswordController;
  final FocusNode oldPasswordFocusNode;
  final TextEditingController newPasswordController;
  final FocusNode newPasswordFocusNode;
  final TextEditingController confirmNewPasswordController;
  final FocusNode confirmNewPasswordFocusNode;
  final double screenHeight;
  final double screenWidth;
  final MainCubit mainCubit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: CustomTextFormField(
              prefixIcon: Icons.lock_outline_rounded,
              controller: oldPasswordController,
              focusNode: oldPasswordFocusNode,
              textInputAction: TextInputAction.next,
              hintText: AppString.oldPassword,
              textInputType: TextInputType.visiblePassword,
              validator: (value) {
                return MyValidators.passwordValidator(value);
              },
              onFieldSubmitted: (value) {
                newPasswordFocusNode.requestFocus();
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
            child: CustomTextFormField(
              prefixIcon: Icons.lock_outline_rounded,
              controller: newPasswordController,
              focusNode: newPasswordFocusNode,
              textInputAction: TextInputAction.next,
              hintText: AppString.newPassword,
              textInputType: TextInputType.visiblePassword,
              validator: (value) {
                return MyValidators.passwordValidator(value);
              },
              onFieldSubmitted: (value) {
                confirmNewPasswordFocusNode.requestFocus();
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
            child: CustomTextFormField(
              prefixIcon: Icons.lock_outline_rounded,
              controller: confirmNewPasswordController,
              focusNode: confirmNewPasswordFocusNode,
              textInputAction: TextInputAction.next,
              hintText: AppString.confirmNewPassword,
              textInputType: TextInputType.visiblePassword,
              validator: (value) {
                return MyValidators.repeatPasswordValidator(
                  value: newPasswordController.text,
                );
              },
              onFieldSubmitted: (value) {},
            ),
          ),
          SliverToBoxAdapter(
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    Text(
                      AppString.strongPassword,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    defaultTextButton(
                      function: () {
                        navigateTo(context, const InstructionsPasswordScreen());
                      },
                      text: AppString.learnMore,
                      context: context,
                      color: ColorManager.primaryColor,
                      fontSize: 20,
                    ),
                  ],
                )),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: screenHeight * .1,
            ),
          ),
          SliverToBoxAdapter(
            child: defaultMaterialButton(
              width: screenWidth * .6,
              function: () {
                if (formKey.currentState!.validate()) {
                  mainCubit.changeUserPassword(
                    oldPassword: oldPasswordController.text,
                    newPassword: newPasswordController.text,
                    confirmNewPassword: confirmNewPasswordController.text,
                  );
                }
              },
              text: AppString.changePassword,
              context: context,
              color: ColorManager.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

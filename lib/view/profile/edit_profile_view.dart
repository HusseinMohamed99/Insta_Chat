import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/model/user_model.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/shared/components/logout.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/shared/components/text_form_field.dart';
import 'package:insta_chat/utils/app_string.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/my_validators.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/password/change_password_view.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController bioController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final FocusNode nameFocusNode = FocusNode();
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode bioFocusNode = FocusNode();
    final FocusNode phoneFocusNode = FocusNode();

    MainCubit mainCubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is UpdateUserSuccessState) {
          showToast(
            text: 'update Data Successfully',
            state: ToastStates.success,
          );
        }
      },
      builder: (context, state) {
        UserModel? userModelData = MainCubit.get(context).userModel;
        File? profileImage = MainCubit.get(context).profileImage;

        emailController.text = userModelData!.email;
        bioController.text = userModelData.bio;
        nameController.text = userModelData.name;
        phoneController.text = userModelData.phone;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
            title: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  profileImage == null
                      ? CircleAvatar(
                          backgroundColor: ColorManager.dividerColor,
                          radius: 55,
                          child: CircleAvatar(
                            radius: 50,
                            child: imageWithShimmer(
                              userModelData.image,
                              radius: 75,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: ColorManager.dividerColor,
                          radius: 55,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundImage: FileImage(profileImage),
                          ),
                        ),
                  Positioned(
                    bottom: 5,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: ColorManager.black,
                      radius: 20,
                      child: IconButton(
                        onPressed: () {
                          mainCubit.getProfileImage();
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p20,
                    vertical: AppPadding.p20,
                  ),
                  width: screenWidth,
                  height: screenHeight,
                  decoration: ShapeDecoration(
                    color: ColorManager.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppPadding.p20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          controller: nameController,
                          hintText: AppString.name,
                          prefixIcon: Icons.person,
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            return MyValidators.displayNameValidator(value);
                          },
                          focusNode: nameFocusNode,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppPadding.p20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          controller: emailController,
                          hintText: AppString.email,
                          prefixIcon: Icons.email_outlined,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                          focusNode: emailFocusNode,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppPadding.p20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          controller: bioController,
                          hintText: AppString.bio,
                          prefixIcon: Icons.info_outline,
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Bio must not be empty';
                            }
                            return null;
                          },
                          focusNode: bioFocusNode,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppPadding.p20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CustomTextFormField(
                          controller: phoneController,
                          hintText: AppString.phone,
                          prefixIcon: Icons.phone,
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            return MyValidators.phoneValidator(value);
                          },
                          focusNode: phoneFocusNode,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppPadding.p20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: defaultMaterialButton(
                          function: () {
                            updateUserData(
                              mainCubit,
                              emailController,
                              phoneController,
                              nameController,
                              bioController,
                            );
                          },
                          text: AppString.update,
                          context: context,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: AppPadding.p20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: defaultMaterialButton(
                          function: () {
                            navigateTo(context, const ChangePasswordScreen());
                          },
                          text: AppString.changePassword,
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
                          children: [
                            Expanded(
                              child: defaultMaterialButton(
                                function: () {
                                  mainCubit.deleteAccount(
                                      buildContext: context);
                                },
                                text: AppString.delete,
                                context: context,
                                color: ColorManager.error,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: defaultMaterialButton(
                                function: () {
                                  logOut(buildContext: context);
                                },
                                text: AppString.logOut,
                                context: context,
                                color: ColorManager.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void updateUserData(
    MainCubit cubit,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController nameController,
    TextEditingController bioController,
  ) {
    if (cubit.profileImage != null) {
      cubit.uploadProfileImage(
        email: emailController.text,
        phone: phoneController.text,
        name: nameController.text,
        bio: bioController.text,
      );
    } else {
      cubit.updateUserData(
        email: emailController.text,
        phone: phoneController.text,
        name: nameController.text,
        bio: bioController.text,
      );
    }
  }
}

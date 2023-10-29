import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/model/user_model.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/shared/components/show_toast.dart';
import 'package:insta_chat/shared/components/text_form_field.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';

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
              'Profile Screen',
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
                      backgroundColor: ColorManager.darkGrey,
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
                          hintText: 'Name',
                          prefixIcon: Icons.person,
                          textInputType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Name must not be empty';
                            }
                            return null;
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
                          hintText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Email must not be empty';
                            }
                            return null;
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
                          hintText: 'Bio',
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
                          hintText: 'Phone',
                          prefixIcon: Icons.phone,
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Phone must not be empty';
                            }
                            return null;
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
                          text: 'Update',
                          context: context,
                          color: ColorManager.primaryColor,
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
    }
  }
}

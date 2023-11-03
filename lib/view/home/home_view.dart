import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_chat/cubits/main/main_cubit.dart';
import 'package:insta_chat/cubits/main/main_state.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/shared/components/image_with_shimmer.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/widget/users_online.dart';
import 'package:insta_chat/utils/app_string.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/profile/edit_profile_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);

        return ModalProgressHUD(
          inAsyncCall: state is GetUserDataLoadingState,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leadingWidth: 120,
                title: Text(
                  AppString.conversations,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: AppPadding.p12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p20, vertical: AppPadding.p20),
                      child: GestureDetector(
                        onTap: () {
                          MainCubit.get(context).getUserData();
                          navigateTo(
                            context,
                            const EditProfileScreen(),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: ColorManager.backgroundGreyGrey,
                          radius: 50,
                          child: cubit.userModel!.image.isNotEmpty
                              ? ImageWithShimmer(
                                  radius: 50,
                                  imageUrl: cubit.userModel!.image,
                                  width: 90,
                                  height: 90,
                                  boxFit: BoxFit.fill,
                                )
                              : CircleAvatar(
                                  backgroundColor:
                                      ColorManager.backgroundGreyGrey,
                                  radius: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: SvgPicture.asset(
                                      Assets.imagesAvatar,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p2,
                          vertical: AppPadding.p20,
                        ),
                        width: screenWidth,
                        height: screenHeight,
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
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
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => BuildUsersItems(
                                  users: cubit.users[index],
                                ),
                                childCount: cubit.users.length,
                              ),
                            ),
                          ],
                        ),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/shared/components/image_with_shimmer.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/widget/users_online.dart';
import 'package:insta_chat/utils/app_string.dart';
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
      listener: (context, state) {
        if (state is GetUserDataErrorState) {
          print(state.error);
        }
        if (state is GetUserDataSuccessState) {
          print(MainCubit.get(context).userModel!.name);
        }
      },
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
                leading: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                  child: GestureDetector(
                    onTap: () {
                      MainCubit.get(context).getUserData();
                      navigateTo(
                        context,
                        const EditProfileScreen(),
                      );
                    },
                    child: CircleAvatar(
                      radius: 30,
                      child: cubit.userModel!.image.isNotEmpty
                          ? ImageWithShimmer(
                              radius: 30,
                              imageUrl: cubit.userModel!.image,
                              width: 60,
                              height: 60,
                              boxFit: BoxFit.fill,
                            )
                          : CircleAvatar(
                              radius: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: SvgPicture.asset(
                                  Assets.imagesAvatar,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
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
                    Expanded(
                      flex: 1,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => BuildUsersOnlineItems(
                          users: cubit.users[index],
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                        itemCount: cubit.users.length,
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

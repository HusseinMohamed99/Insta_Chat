import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_chat/cubits/main/main_cubit.dart';
import 'package:insta_chat/cubits/main/main_state.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/model/user_model.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
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
              'Profile',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                backgroundColor: ColorManager.dividerColor,
                radius: 55,
                child: CircleAvatar(
                  radius: 50,
                  child: imageWithShimmer(
                    userModel.image,
                    radius: 75,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.center,
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
                      SliverToBoxAdapter(
                        child: Text(
                          userModel.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: ColorManager.black),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Text(
                          userModel.email,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Text(
                          userModel.bio,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String url = userModel.phone;
                                await urlLauncher(
                                    Uri.parse('http://wa.me/+2$url'));
                              },
                              child: CircleAvatar(
                                backgroundColor: ColorManager.primaryColor,
                                radius: 30,
                                child: SvgPicture.asset(
                                  Assets.imagesMessages,
                                  width: 45,
                                  height: 45,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String number = userModel.phone;
                                await urlLauncher(Uri.parse('tel://+2$number'));

                                await FlutterPhoneDirectCaller.callNumber(
                                    number);
                              },
                              child: CircleAvatar(
                                backgroundColor: ColorManager.primaryColor,
                                radius: 30,
                                child: SvgPicture.asset(
                                  Assets.imagesPhone,
                                  width: 45,
                                  height: 45,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String url = userModel.email;
                                await urlLauncher(Uri.parse('mailto:$url'));
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: ColorManager.primaryColor,
                                child: SvgPicture.asset(
                                  Assets.imagesGmail,
                                  width: 45,
                                  height: 45,
                                ),
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
}

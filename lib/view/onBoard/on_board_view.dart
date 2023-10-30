import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/font_manager.dart';
import 'package:insta_chat/view/home/home_view.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const ShapeDecoration(
                color: Colors.white, shape: RoundedRectangleBorder()),
            child: Column(
              children: [
                SizedBox(
                  width: screenWidth * .8,
                  height: screenHeight * .5,
                  child: SvgPicture.asset(Assets.imagesVector),
                ),
                const Spacer(),
                Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: ColorManager.black,
                        fontWeight: FontWeightManager.bold,
                      ),
                ),
                Text(
                  'Insta-Chat is the best Messaging\nApp on the planet',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: ColorManager.black),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    MainCubit.get(context).getUserData();
                    navigateTo(
                      context,
                      const HomeScreen(),
                    );
                  },
                  child: Container(
                    width: 230,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF376AED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

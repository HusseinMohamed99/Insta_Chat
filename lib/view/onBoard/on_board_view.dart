import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/view/home/home_view.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const ShapeDecoration(
                  color: Colors.white, shape: RoundedRectangleBorder()),
              child: Stack(
                children: [
                  Positioned(
                    left: 81,
                    top: 705,
                    child: GestureDetector(
                      onTap: () {
                        MainCubit.get(context).getUserData();
                        navigateTo(
                          context,
                          const HomeScreen(),
                        );
                      },
                      child: SizedBox(
                        width: 230,
                        height: 60,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 123,
                    top: 518,
                    child: Text(
                      'Welcome',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 66,
                    top: 570,
                    child: Text(
                      'Insta-Chat is the best Messaging\nApp on the planet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 33,
                    top: 107,
                    child: SizedBox(
                      width: 324,
                      height: 324,
                      child: SvgPicture.asset(Assets.imagesVector),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

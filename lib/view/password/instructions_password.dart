import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubits/main/main_cubit.dart';
import 'package:insta_chat/cubits/main/main_state.dart';
import 'package:insta_chat/shared/components/buttons.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/utils/app_string.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';

class InstructionsPasswordScreen extends StatelessWidget {
  const InstructionsPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    List<String> instructionsChangePassword = [
      AppString.strongPasswordLength,
      AppString.smallAndCapitalLetters,
      AppString.includeFigures,
      AppString.specialCharacters,
      AppString.exampleStrongPassword,
    ];
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
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
                    child: InstructionsChangePasswordBody(
                      instructionsChangePassword: instructionsChangePassword,
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

class InstructionsChangePasswordBody extends StatelessWidget {
  const InstructionsChangePasswordBody({
    super.key,
    required this.instructionsChangePassword,
    required this.screenWidth,
  });

  final List<String> instructionsChangePassword;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
              child: Text(
                instructionsChangePassword[index],
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.start,
              ),
            );
          }, childCount: instructionsChangePassword.length),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 48),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(AppPadding.p8),
            decoration: BoxDecoration(
              color: const Color(0xFF03BC42).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                AppString.examplePassword,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 35),
        ),
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: defaultMaterialButton(
              function: () {
                pop(context);
              },
              text: AppString.gotIt,
              context: context,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    MainCubit mainCubit = MainCubit.get(context);

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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: ColorManager.dividerColor,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    child: imageWithShimmer(
                      mainCubit.userModel!.image,
                      radius: 75,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s20),
                Text(
                  mainCubit.userModel!.name,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    String number = mainCubit.userModel!.phone;
                    await urlLauncher(Uri.parse('tel://+2$number'));
                    await FlutterPhoneDirectCaller.callNumber(number);
                  },
                  icon: const Icon(Icons.call),
                ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => const BuildOwnMessages(),
                          childCount: 1,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => const BuildFriendMessages(),
                          childCount: 1,
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

class BuildOwnMessages extends StatelessWidget {
  const BuildOwnMessages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: ColorManager.primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSize.s28),
            topRight: Radius.circular(AppSize.s28),
            bottomRight: Radius.circular(AppSize.s28),
          ),
        ),
        child: Text(
          'Hello',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: ColorManager.white),
        ),
      ),
    );
  }
}

class BuildFriendMessages extends StatelessWidget {
  const BuildFriendMessages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: ColorManager.primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSize.s28),
            topRight: Radius.circular(AppSize.s28),
            bottomLeft: Radius.circular(AppSize.s28),
          ),
        ),
        child: Text(
          'Hello',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: ColorManager.white),
        ),
      ),
    );
  }
}

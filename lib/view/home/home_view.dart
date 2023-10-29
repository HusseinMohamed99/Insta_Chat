import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/shared/widget/users_online.dart';
import 'package:insta_chat/utils/app_string.dart';
import 'package:insta_chat/utils/value_manager.dart';
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
                title: Text(
                  AppString.conversations,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => BuildUsersOnlineItems(
                        users: cubit.users[index],
                        gestureDetector: () {
                          print(cubit.users[index].name);
                        },
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
        );
      },
    );
  }
}

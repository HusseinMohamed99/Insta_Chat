import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_chat/cubit/main/main_cubit.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/model/user_model.dart';
import 'package:insta_chat/shared/components/image_with_shimmer.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:insta_chat/view/chat/chat_view.dart';
import 'package:insta_chat/view/profile/profile_view.dart';

class BuildUsersOnlineItems extends StatelessWidget {
  const BuildUsersOnlineItems({
    super.key,
    required this.users,
  });
  final UserModel users;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MainCubit.get(context).getUserData();
        navigateTo(
          context,
          const ProfileScreen(),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsetsDirectional.all(AppPadding.p12),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: users.image.isNotEmpty
                      ? ImageWithShimmer(
                          radius: 30,
                          imageUrl: users.image,
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
                CircleAvatar(
                  radius: 8,
                  backgroundColor: ColorManager.white,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: ColorManager.success,
                  ),
                ),
              ],
            ),
            Text(
              users.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }
}

class BuildUsersItems extends StatelessWidget {
  const BuildUsersItems({super.key, required this.users});
  final UserModel users;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(
          context,
          const ChatScreen(),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: users.image.isNotEmpty
                  ? ImageWithShimmer(
                      radius: 30,
                      imageUrl: users.image,
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
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                users.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () {
                // navigateTo(
                //   context,
                //   PrivateChatScreen(userModel: users),
                // );
              },
              label: Text(
                'message',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              icon: const Icon(
                Icons.chat,
              ),
            )
          ],
        ),
      ),
    );
  }
}

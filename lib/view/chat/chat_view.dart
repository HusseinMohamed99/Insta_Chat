import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:insta_chat/cubits/main/main_cubit.dart';
import 'package:insta_chat/cubits/main/main_state.dart';
import 'package:insta_chat/image_assets.dart';
import 'package:insta_chat/model/message_model.dart';
import 'package:insta_chat/model/user_model.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/shared/components/indicator.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.userModel});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    MainCubit mainCubit = MainCubit.get(context);
    final formKey = GlobalKey<FormState>();
    final textController = TextEditingController();

    Uuid uuid = const Uuid();
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is SendMessageSuccessState) {
          if (mainCubit.messageImagePicked != null) {
            mainCubit.removeMessageImage();
          }

          textController.clear();
        }
      },
      builder: (context, state) {
        mainCubit.getMessage(
          receiverId: userModel.uid,
        );
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ModalProgressHUD(
            inAsyncCall: state is UploadMessageImageLoadingState,
            progressIndicator: const AdaptiveIndicator(),
            child: Scaffold(
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
                          userModel.image,
                          radius: 75,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSize.s20),
                    Expanded(
                      child: Text(
                        userModel.name,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
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
              body: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                      vertical: AppPadding.p20,
                    ),
                    width: screenWidth,
                    height: screenHeight,
                    decoration: ShapeDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          Assets.imagesBackgroundImage,
                        ),
                      ),
                      color: ColorManager.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                    ),
                    child: CustomScrollView(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              MessageModel message = mainCubit.message[index];
                              if (mainCubit.userModel!.uid ==
                                  message.senderId) {
                                return BuildOwnMessages(
                                  messageModel: message,
                                );
                              } else {
                                return BuildFriendMessages(
                                  messageModel: message,
                                );
                              }
                            },
                            childCount: mainCubit.message.length,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 100),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (mainCubit.messageImagePicked != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 170,
                          decoration: BoxDecoration(
                            color: ColorManager.backgroundGreyGrey,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: FileImage(mainCubit.messageImagePicked!),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: ColorManager.primaryColor,
                          child: IconButton(
                            onPressed: () {
                              mainCubit.removeMessageImage();
                            },
                            icon: Icon(
                              Icons.close_outlined,
                              color: ColorManager.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  Form(
                    key: formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            maxLines: 3,
                            minLines: 1,
                            controller: textController,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'message',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: ColorManager.backgroundGreyGrey,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  size: 20,
                                  color: ColorManager.grey,
                                ),
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      mainCubit.getMessageImage();
                                    },
                                    icon: Icon(
                                      Icons.camera,
                                      size: 24,
                                      color: ColorManager.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            validator: (String? value) {
                              if (value!.trim().isEmpty) {
                                return 'message';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            color: ColorManager.primaryColor,
                            onPressed: () {
                              sendMessageMethod(
                                mainCubit,
                                formKey,
                                textController,
                                uuid,
                                context,
                              );
                              controller.animateTo(
                                controller.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 500),
                              );
                              // controller
                              //     .jumpTo(controller.position.maxScrollExtent);
                            },
                            child: Icon(
                              Icons.upload_outlined,
                              color: ColorManager.white,
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
        );
      },
    );
  }

  void sendMessageMethod(MainCubit mainCubit, GlobalKey<FormState> formKey,
      TextEditingController textController, Uuid uuid, BuildContext context) {
    if (mainCubit.messageImagePicked == null &&
        formKey.currentState!.validate()) {
      mainCubit.sendMessage(
        receiverId: userModel.uid,
        dateTime: DateTime.now().toString(),
        text: textController.text.trim(),
        messageId: uuid.v4(),
      );
      textController.clear();
    } else if (mainCubit.messageImagePicked != null) {
      MainCubit.get(context).uploadMessageImage(
        receiverId: userModel.uid,
        dateTime: DateTime.now().toString(),
        text: textController.text,
        messageId: uuid.v4(),
      );
      textController.clear();
      mainCubit.removeMessageImage();
    } else {}
    mainCubit.sendFCMNotification(
      senderName: mainCubit.userModel!.name,
      messageText: textController.text,
      messageImage: mainCubit.imageURL,
      token: userModel.token,
    );
  }
}

class BuildOwnMessages extends StatelessWidget {
  const BuildOwnMessages({
    super.key,
    required this.messageModel,
  });
  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    if (messageModel.messageImage == '') {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p16),
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
            '${messageModel.text}',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: ColorManager.white),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 250,
          height: 200,
          padding: const EdgeInsets.all(AppPadding.p12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorManager.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSize.s28),
              topRight: Radius.circular(AppSize.s28),
              bottomLeft: Radius.circular(AppSize.s28),
            ),
          ),
          child: imagePreview(
            '${messageModel.messageImage}',
          ),
        ),
      );
    }
  }
}

class BuildFriendMessages extends StatelessWidget {
  const BuildFriendMessages({
    super.key,
    required this.messageModel,
  });
  final MessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    if (messageModel.messageImage == '') {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorManager.secondaryPrimaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSize.s28),
              topRight: Radius.circular(AppSize.s28),
              bottomRight: Radius.circular(AppSize.s28),
            ),
          ),
          child: Text(
            '${messageModel.text}',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: ColorManager.black),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 250,
          height: 200,
          padding: const EdgeInsets.all(AppPadding.p12),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorManager.secondaryPrimaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSize.s28),
              topRight: Radius.circular(AppSize.s28),
              bottomRight: Radius.circular(AppSize.s28),
            ),
          ),
          child: imagePreview(
            '${messageModel.messageImage}',
          ),
        ),
      );
    }
  }
}

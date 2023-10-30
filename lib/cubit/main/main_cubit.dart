import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_chat/cubit/main/main_state.dart';
import 'package:insta_chat/model/message_model.dart';
import 'package:insta_chat/model/notifications_model.dart';
import 'package:insta_chat/model/user_model.dart';
import 'package:insta_chat/shared/components/constants.dart';
import 'package:insta_chat/shared/components/navigator.dart';
import 'package:insta_chat/shared/network/cache_helper.dart';
import 'package:insta_chat/shared/network/dio_helper.dart';
import 'package:insta_chat/view/onBoard/on_board_view.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());
  static MainCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void getUserData() {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      setUserToken();
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      emit(GetUserDataErrorState(error: error.toString()));
    });
  }

  List<UserModel> users = [];
  void getAllUsers() {
    emit(GetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((event) {
      users = [];
      for (var element in event.docs) {
        if (element.data()['uid'] != uId) {
          users.add(UserModel.fromJson(element.data()));
        }
      }
      emit(GetAllUsersSuccessState());
    }).catchError((error) {
      emit(GetAllUsersErrorState(error: error.toString()));
    });
  }

  void setUserToken() async {
    emit(SetUSerTokenLoadingState());
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('users').doc(uId).update(
        {'token': token}).then((value) => emit(SetUSerTokenSuccessState()));
  }

  var picker = ImagePicker();
  File? profileImage;

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      profileImage = await cropImage(imageFile: profileImage!);
      emit(GetProfileImagePickedSuccessState());
    } else {
      emit(GetProfileImagePickedErrorState());
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage != null) {
      return File(croppedImage.path);
    }
    return null;
  }

  void uploadProfileImage({
    required String email,
    required String phone,
    required String name,
    required String bio,
  }) {
    emit(UpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'userProfileImage/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(
          email: email,
          phone: phone,
          name: name,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  void updateUserData({
    required String email,
    required String phone,
    required String name,
    required String bio,
    String? image,
  }) {
    emit(UpdateUserLoadingState());
    UserModel model = UserModel(
      email: email,
      phone: phone,
      name: name,
      bio: bio,
      image: image ?? userModel!.image,
      uid: userModel!.uid,
      isEmailVerified: userModel!.isEmailVerified,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .update(model.toMap())
        .then((value) {
      emit(UpdateUserSuccessState());
      getUserData();
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }

  MessageModel? messageModel;
  void sendMessage({
    required String receiverId,
    required String messageId,
    required String dateTime,
    String? text,
    String? messageImage,
  }) {
    MessageModel model = MessageModel(
      messageId: messageId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text ?? '',
      senderId: userModel!.uid,
      messageImage: messageImage ?? '',
      time: FieldValue.serverTimestamp(),
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uid)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> message = [];
  void getMessage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .orderBy('time')
        .snapshots()
        .listen((event) {
      message = [];
      for (var element in event.docs) {
        message.add(MessageModel.fromJson(element.data()));
      }
      emit(GetMessageSuccessState());
    });
  }

  File? messageImagePicked;
  Future<void> getMessageImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImagePicked = File(pickedFile.path);
      emit(MessageImagePickedSuccessState());
    } else {
      emit(MessageImagePickedErrorState());
    }
  }

  void removeMessageImage() {
    messageImagePicked = null;
    emit(DeleteMessageImageSuccessState());
  }

  void uploadMessageImage({
    required String receiverId,
    required String messageId,
    required String dateTime,
    String? text,
  }) {
    emit(UploadMessageImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'messagesImage/${Uri.file(messageImagePicked!.path).pathSegments.last}')
        .putFile(messageImagePicked!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
          dateTime: dateTime,
          text: text,
          messageImage: value,
          receiverId: receiverId,
          messageId: messageId,
        );
      }).catchError((error) {
        emit(UploadMessageImageErrorState());
      });
    }).catchError((error) {
      emit(UploadMessageImageErrorState());
    });
  }

  void deleteForEveryone(
      {required String? messageId, required String? receiverId}) async {
    var myDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chat')
        .doc(receiverId!)
        .collection('message')
        .limit(1)
        .where('messageId', isEqualTo: messageId)
        .get();
    myDocument.docs[0].reference.delete();
    var hisDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uid)
        .collection('message')
        .limit(1)
        .where('messageId', isEqualTo: messageId)
        .get();
    hisDocument.docs[0].reference.delete();
  }

  String? imageURL;
  Future<void> sendFCMNotification({
    required String token,
    required String senderName,
    String? messageText,
    String? messageImage,
  }) async {
    DioHelper.postData(data: {
      "to": token,
      "notification": {
        "title": senderName,
        "body": messageText ?? (messageImage != null ? 'Photo' : 'ERROR 404'),
        "sound": "default"
      },
      "android": {
        "Priority": "HIGH",
      },
      "data": {
        "type": "order",
        "id": "87",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    });
    emit(SendFCMNotificationSuccessState());
  }

  void sendInAppNotification({
    String? contentKey,
    String? contentId,
    String? content,
    String? receiverName,
    String? receiverId,
  }) {
    emit(SendInAppNotificationLoadingState());
    NotificationModel notificationModel = NotificationModel(
      contentKey: contentKey,
      contentId: contentId,
      content: content,
      senderName: userModel!.name,
      receiverName: receiverName,
      senderId: userModel!.uid,
      receiverId: receiverId,
      senderImage: userModel!.image,
      read: false,
      dateTime: DateTime.now(),
      serverTimeStamp: FieldValue.serverTimestamp(),
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('notifications')
        .add(notificationModel.toMap())
        .then((value) async {
      await setNotificationId();
      emit(SendInAppNotificationLoadingState());
    }).catchError((error) {
      emit(SendInAppNotificationLoadingState());
    });
  }

  Future setNotificationId() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) async {
        var notifications =
            await element.reference.collection('notifications').get();
        notifications.docs.forEach((notificationsElement) async {
          await notificationsElement.reference
              .update({'notificationId': notificationsElement.id});
        });
      });
      emit(SetNotificationIdSuccessState());
    });
  }

  void deleteForMe(
      {required String? messageId, required String? receiverId}) async {
    var myDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .limit(1)
        .where('messageId', isEqualTo: messageId)
        .get();
    myDocument.docs[0].reference.delete();
  }

  void deleteAccount({required buildContext}) async {
    await FirebaseAuth.instance.currentUser!.delete().then((value) async {
      await FirebaseFirestore.instance.collection('users').doc(uId).delete();
      CacheHelper.removeData(key: 'uId');
      navigateAndFinish(buildContext, const OnBoardScreen());
    });
  }
}

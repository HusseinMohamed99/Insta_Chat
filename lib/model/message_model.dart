import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? messageId;
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;
  String? messageImage;
  FieldValue? time;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.text,
    this.messageId,
    this.messageImage,
    this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      dateTime: json['dateTime'],
      text: json['text'],
      messageId: json['messageId'],
      messageImage: json['messageImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'dateTime': dateTime,
      'receiverId': receiverId,
      'senderId': senderId,
      'messageId': messageId,
      'messageImage': messageImage,
      'time': time,
    };
  }
}

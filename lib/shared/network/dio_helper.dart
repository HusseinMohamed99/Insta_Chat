import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    debugPrint('dioHelper Initialized');
    dio = Dio(BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> postData({Map<String, dynamic>? data}) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key =  AAAAoFyjg7w:APA91bHGlmCq6yumbtkFkjmoPRJmcMOOCCg1b4T1RPcb-gkhGQffC-e_rkwjOaKTE_0AOy9R33vaZ38tidypeZQBahFvYy_nI817-2bIeFHLZ7XquoVvZYB8vioP_dC4JnFadikkG1v-'
    };
    return await dio.post(
      'https://fcm.googleapis.com/fcm/send',
      data: data,
    );
  }
}

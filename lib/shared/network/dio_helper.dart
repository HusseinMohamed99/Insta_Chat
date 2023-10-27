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
      'Authorization': 'key = NEED KEY'
    };
    return await dio.post(
      'https://fcm.googleapis.com/fcm/send',
      data: data,
    );
  }
}

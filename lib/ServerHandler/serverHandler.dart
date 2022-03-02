import 'dart:developer';

import 'package:dio/dio.dart';

class ServerHandler {
  Future getDataFromApi() async {
    try {
      Response response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
      return response;
    } catch (e) {
      log(e.toString());
    }
  }
}

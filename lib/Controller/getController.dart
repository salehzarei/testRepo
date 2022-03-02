import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_test/ServerHandler/serverHandler.dart';
import 'package:flutter_application_test/postModel.dart';
import 'package:get/get.dart';

class MyController extends GetxController {
  Database? database;

  @override
  void onInit() async {
    super.onInit();
    // Init Data base and Create Table First Time
    database = await openDatabase('database.db', version: 1,
        onCreate: (Database database, int version) async {
      await database.execute(
          'CREATE TABLE Test (userId INTEGER,id INTEGER ,title TEXT, body TEXT)');
    });
  }

  @override
  void onClose() {
    super.onClose();
    database?.close();
  }

  final postList = <PostModel>[].obs;
  // local data list
  final localPostList = <PostModel>[].obs;
  final isLoadingDataFromServer = false.obs;

  Future getPostData() async {
    isLoadingDataFromServer(true);
    update();
    await ServerHandler().getDataFromApi().then((response) => {
          // add Fetch Data to Post List
          postList(List<PostModel>.from(
              response.data.map((data) => PostModel.fromJson(data))).toList())
        });

    log(" Length of Posts fetched is : " + postList.length.toString());

// Insert Fetched Data To Local Data base

// check Data base is open ?
    log(database?.isOpen.toString() ?? 'no Data base');
// if database is open then add fetch data to local data base
    if (database?.isOpen ?? false) {
      var batch = database?.batch();
      postList.forEach((element) {
        batch?.insert('Test', element.toJson());
      });
      var result = await batch?.commit();
      log(result.toString());
    }

    isLoadingDataFromServer(false);
    update();
  }

  Future loadDataFromLocal() async {
    isLoadingDataFromServer(true);
    update();
    var list = await database?.rawQuery('SELECT * FROM Test');
    // convert List Raw Data to List Of Post
    localPostList(
        List<PostModel>.from(list!.map((data) => PostModel.fromJson(data)))
            .toList());

    isLoadingDataFromServer(false);
    update();
    log("LISt : " + list.toString());
  }
}

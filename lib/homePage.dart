import 'package:flutter/material.dart';
import 'package:flutter_application_test/Controller/getController.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyController());
    return GetBuilder<MyController>(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Test API app'),
                centerTitle: true,
              ),
              body: SizedBox(
                height: 650,
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.isLoadingDataFromServer.value
                        ? const CircularProgressIndicator()
                        : Expanded(
                            child: ListView.builder(
                                itemCount: controller.localPostList.length,
                                itemBuilder: (ctc, index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(controller
                                          .localPostList[index].title!),
                                      leading: Text(controller
                                          .localPostList[index].userId
                                          .toString()),
                                    ),
                                  );
                                }),
                          ),
                    Center(
                      child: controller.isLoadingDataFromServer.value
                          ? const CircularProgressIndicator()
                          : Text("Data Loaded Length" +
                              controller.postList.length.toString()),
                    ),
                    TextButton(
                        onPressed: () => controller.loadDataFromLocal(),
                        child: const Text('Load Data From Database'))
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => controller.getPostData(),
                child: const Icon(Icons.data_saver_on),
              ),
            ));
  }
}

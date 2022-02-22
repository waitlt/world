// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'index.dart';
import 'login.dart';
import 'all_asset.dart';
import 'asset_details.dart';
import 'edit_asset.dart';
import 'edit_asset_horizontal.dart';
import 'select_asset.dart';
import 'people.dart';
import 'login_setting.dart';
import 'figure_login_setting.dart';
import 'package:get_storage/get_storage.dart';

 main() async {
   await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: null,
        resizeToAvoidBottomInset: false,
        body: text(),
      ),
      theme: ThemeData(
          primaryColor: Colors.yellow
      ),
    );
    throw UnimplementedError();
  }

}

class HomeContent extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Center(
      child: Container(
        child: const Text('我是测试文本我是测试文本我是测试文本我是测试文本',
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: 16.0,
              overflow: TextOverflow.ellipsis

          ),
        ),
        height: 300.0,
        width: 300.0,
        decoration:  BoxDecoration(
            color: Colors.yellow,
            border: Border.all(
                color: Colors.blue,
                width: 2.0
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0)
            )
        ),
        padding: const EdgeInsets.all(10.0),
      ),
    );
    throw UnimplementedError();
  }

}

class HomeImage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Center(
        child:Container(
          child: Image.network("https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png"
          ),
          width: 300.0,
          height: 300.0,
          decoration: const BoxDecoration(
              color: Colors.yellow
          ),
        )

    );
    throw UnimplementedError();
  }
}

class HomeListView extends StatelessWidget {
  List list = [];

  HomeListView() {
    for (var i = 0; i < 20; i++) {
      list.add(ListTile(
        title: Text("我是$i列表"),
      ));
    }
  }

  get itemBuilder => null;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: this.list.length,
        itemBuilder: (context, index) {
          return this.list[index];
        }


    );
    throw UnimplementedError();
  }
}


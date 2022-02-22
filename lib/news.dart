import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

class News extends StatefulWidget {
   const News({Key? key}) : super(key: key);

  @override
  _newsState createState() => _newsState();
}

class _newsState extends State<News> {
  @override
  Widget build(BuildContext context) {

    Object? arguments = ModalRoute.of(context)?.settings.arguments;

    Map map=json.decode(json.encode(arguments));


    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );

    return Scaffold(
      backgroundColor: Color(int.parse("0xfff2f2f2")),
      body:  Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child: Text(map["title"],style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        width: ScreenUtil().setWidth(330),
                        child: Image.asset("images/${map["id"]}.jpg",),
                      ),
                    ),
                  )
                  ,
                  Container(
                    margin: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Text(map["contents"],style: TextStyle(color: Colors.black),),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(190, 15, 0, 0),
                    child: Text(map["createTime"],style: TextStyle(color: Colors.red),),
                  )

                ],
              ),
          )
          ,

    );
  }
}

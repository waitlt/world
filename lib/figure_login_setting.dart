

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gesture_password_widget/gesture_password_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:list_ext/list_ext.dart';
import 'package:qahfkajfh/people.dart';

class FigureSetting extends StatefulWidget {
  const FigureSetting({Key? key}) : super(key: key);

  @override
  _FigureSettingState createState() => _FigureSettingState();
}

class _FigureSettingState extends State<FigureSetting> {
  List list=[];
  bool ok=true;
  @override
  initState()  {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );

    var box=GetStorage();
    bool ok=true;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse("0xfff2f2f2")),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(40),
                  color: Color(int.parse("0xffd7d7d7")),
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          width: ScreenUtil().setWidth(25),
                          height: ScreenUtil().setHeight(25),
                          child: Image.asset("images/icon-left.png",fit: BoxFit.fill,),
                        ),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text("Figure Login Setting",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),),
                      )

                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30,top: 30),
                  child: Text("请连续输入两次手势设置密码",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                ),
                Container(
                  height: ScreenUtil().setHeight(400),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image:DecorationImage(
                                image: AssetImage("images/backgrond.jpg"),
                                fit: BoxFit.fill
                            )
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: GesturePasswordWidget(
                          lineColor: Colors.white,
                          errorLineColor: Colors.red,
                          singleLineCount: 3,
                          identifySize: 80,
                          minLength: 4,
                          normalItem: Container(
                            width: ScreenUtil().setWidth(10),
                            height: ScreenUtil().setHeight(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(100))
                            ),
                          ),
                          selectedItem: Container(
                            width: ScreenUtil().setWidth(10),
                            height: ScreenUtil().setHeight(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(100))
                            ),
                          ),
                          errorItem:
                          Container(
                            width: ScreenUtil().setWidth(10),
                            height: ScreenUtil().setHeight(10),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(100))
                            ),
                          ),
                          hitItem: Container(
                            width: ScreenUtil().setWidth(15),
                            height: ScreenUtil().setHeight(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(100))
                            ),
                          ),
                          color: Color(int.parse("0x00f2f2f2")),
                          size: 330,
                          completeWaitMilliseconds:1,
                          onComplete: (data){
                            if(list.isEmpty){
                              data.forEach((element) {
                                list.add(element);
                              });
                              Fluttertoast.showToast(msg: "请再次输入密码");
                            }else{
                              if(list.length==data.length){
                                if(list.containsAll(data)){
                                  Fluttertoast.showToast(msg: "手势密码设置成功");
                                  box.write("figure_password", list);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                    return People();
                                  }));
                                }else{
                                  Fluttertoast.showToast(msg: "两次密码不一致,请重新输入");
                                }
                              }else{
                                  Fluttertoast.showToast(msg: "两次密码不一致,请重新输入");
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qahfkajfh/edit_asset.dart';
import 'package:get_storage/get_storage.dart';
import 'figure_login_setting.dart';
class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool ok=false;
  @override
  Widget build(BuildContext context) {
    TextEditingController password=TextEditingController();
    var box=GetStorage();
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse("0xfff2f2f2")),
          body:GestureDetector(
            behavior: HitTestBehavior.translucent,
            child:  Column(
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
                        child: Text("Figure Login Setting",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                      )

                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20,left: 30),
                  child: Row(
                    children: [
                      Switch(
                          value: ok,
                          activeColor: Colors.yellow,
                          activeTrackColor: Colors.orange,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          onChanged: (value){
                            box.write("OK", value);
                            setState(() {
                              ok=value;
                            });
                          }),
                      Text("Figure Login",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54))
                    ],
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(290),
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.centerLeft,
                  child: Text("Please Input your login password",style: TextStyle(fontWeight: FontWeight.bold,color: Color(int.parse("0xff7a7a7a")),fontSize: 13),),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20,left: 38),
                        height: ScreenUtil().setHeight(30),
                        width: ScreenUtil().setWidth(200),
                        child: TextField(
                          controller: password,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.lightGreenAccent)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 0.9)),
                          ),
                          obscureText: true,
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setHeight(30),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            if(ok){
                              if("123456"==password.text){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                  return FigureSetting();
                                }));
                              }else{
                                Fluttertoast.showToast(msg: "密码输入错误");
                              }
                            }else{
                              Fluttertoast.showToast(msg: "您还未打开手势登录服务!");
                            }
                          },
                          child: Text("Next",style: TextStyle(fontSize: 13,color: Color(int.parse("0xff575757"))),),

                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ));
  }
}

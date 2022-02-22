// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qahfkajfh/figure_login.dart';
import 'all_asset.dart';
import 'package:get_storage/get_storage.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  String timeName = "Good morning";
  late TextEditingController telephone;
  late TextEditingController password;

  getTime() {
    int time = int.parse(DateFormat("k").format(DateTime.now()));
    setState(() {
      if ((6 < time) & (time < 12)) {
        timeName = "Good morning";
      } else if ((12 < time) & (time < 18)) {
        timeName = "Good Afternoon";
      } else {
        timeName = "Good Evening";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    telephone = TextEditingController();
    password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    getTime();
    var box=GetStorage();
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );
    return Scaffold(
      backgroundColor: Color(int.parse("0xfff2f2f2")),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(115),
                decoration: BoxDecoration(
                    color: Color(int.parse("0xffaaaaaa")),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                alignment: Alignment(0, 0),
                margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Text(
                  "LOGO",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(218),
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 15),
                    child: Text(
                      timeName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 44, 0),
                    child: Text(
                      "Please login into the system",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 50, 180, 0),
                    child: Text(
                      "Telephone",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(int.parse("0xff555555"))),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(220),
                    child: TextField(
                      controller: telephone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                      ),
                      maxLength: 11,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 180, 0),
                    child: Text(
                      "Password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(int.parse("0xff555555"))),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(220),
                    child: TextField(
                      controller: password,
                      maxLength: 16,
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      decoration: InputDecoration(
                        counterText: "",
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(250),
                    margin: EdgeInsets.fromLTRB(20, 70, 0, 0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(int.parse("0xff818181")), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: MaterialButton(
                      onPressed: () {
                        if ((telephone.text == "110") &
                            (password.text == "123456")) {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                              return allAsset();
                          }));
                        } else {
                          Fluttertoast.showToast(
                              msg: "账号或密码错误");
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Color(int.parse("0xff585858")),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(230, 50, 0, 0),
                    child: InkWell(
                      child: Text(
                        "Figure Login",
                        style: TextStyle(
                            color: Color(int.parse("0xff575757")),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      onTap: (){
                        print(box.read("OK"));
                        if(box.read("OK")==null){
                          Fluttertoast.showToast(msg: "暂未开启手势登录服务");
                        }else{
                          if(box.read("OK")){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return FigureSettingS();
                              }));
                          }else{
                            Fluttertoast.showToast(msg: "暂未开启手势登录服务");
                          };
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

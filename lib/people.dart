// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qahfkajfh/figure_login_setting.dart';
import 'package:qahfkajfh/login_setting.dart';
import 'login.dart';
import 'package:get_storage/get_storage.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {

  @override
  Widget build(BuildContext context) {
    var box=GetStorage();
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse("0xfff2f2f2")),
          body: Container(
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
                        child: Text("My Center",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                      )

                    ],
                  ),
                ),
                Container(
                    height: ScreenUtil().setHeight(100),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 20),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(int.parse("0xff555555")),
                            child: Image.asset("images/icon-mycenter.png",fit: BoxFit.fill,color: Colors.white,height:ScreenUtil().setHeight(70),width:ScreenUtil().setWidth(70),),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(200),
                              margin: EdgeInsets.only(left: 10,top: 50),
                              child: Text("Firstname Lastname",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 19),),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(200),
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.only(top: 10,left: 10),
                              child: Text("Rolename"),
                            )
                          ],
                        )


                      ],
                    ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  height: ScreenUtil().setHeight(7),
                  color: Color(int.parse("0xffd7d7d7")),
                ),
                Container(
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setHeight(30),
                  margin: EdgeInsets.only(top: 60),
                  child: InkWell(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.chevron_right,size: 30,),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          hintText: "Figure Login Setting",
                          hintStyle: TextStyle(color: Color(int.parse("0xff626262")),fontSize: 14,fontWeight: FontWeight.bold)
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return Setting();
                      }));
                    },
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setHeight(2),
                  color: Color(int.parse("0xffe3e3e3")),
                ),
                Container(
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setHeight(30),
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.chevron_right,size: 30,),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none
                        ),
                        hintText: "Modify Password",
                        hintStyle: TextStyle(color: Color(int.parse("0xff626262")),fontSize: 14,fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setHeight(2),
                  color: Color(int.parse("0xffe3e3e3")),
                ),
                Container(
                  margin: EdgeInsets.only(top: 270),
                  width: ScreenUtil().setWidth(280),
                  height: ScreenUtil().setHeight(40),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return login();
                      }));
                      box.erase();
                    },
                    child: Text("Logout",style: TextStyle(color: Color(int.parse("0xff626262")),fontSize: 14,fontWeight: FontWeight.bold),),
                    
                  ),
                )

              ],
            ),
          ),
        )
    );
  }
}

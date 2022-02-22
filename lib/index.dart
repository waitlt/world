// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'news.dart';
import 'login.dart';

class text extends StatefulWidget {
  text({Key? key}) : super(key: key);

  @override
  _textState createState() => _textState();
}

class _textState extends State<text> {
  List images = [];
  List titles=[];
  List list=[];
  var color=int.parse("0xff696969");
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoto();
    getNews();

  }
  getPhoto() async {
    var uri = Uri.parse("http://10.0.2.2:5000/api/Carousel");
    var response = await http.get(uri);
    setState(() {
      if (response.statusCode == 200) {
        for (var item in json.decode(response.body)) {
          images.add(item["photo"]);
        }
      }
    });
  }
  getNews() async {
    var uri=Uri.parse("http://10.0.2.2:5000/api/Announcement");
    var response=await http.get(uri);
    list=json.decode(response.body);
    list.sort((left,right) => right["createTime"]!.compareTo("${left["createTime"]}"));
    List lists=list.sublist(0,5);
    setState(() {
      if(response.statusCode==200){
        titles.add("Company Announcement");
          for (var item in lists) {
            titles.add(item["title"]);
          }
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(int.parse("0xfff2f2f2")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    color: Color(int.parse("0xffd7d7d7")),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Align(
                          alignment: Alignment(-0.80, 0),
                          child: Text("Skward Company Management System",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        Align(
                          alignment: Alignment(0.95, 0),
                          child: InkWell(
                            child: Text("Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14)),
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                return login();
                              }));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 3, 15, 10),
                      color: Color(int.parse("0xffffffff")),
                      margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
                      child: Swiper(
                          pagination: SwiperPagination(
                                builder:RectSwiperPaginationBuilder(
                                  activeColor:Color(int.parse("0xffcccccc")),
                                  color: Colors.white,
                                  size:  Size(40.0, 10.0),
                                  activeSize:  Size(40.0, 10.0)
                                )
                          ),
                          itemCount:images.length,
                          autoplay: true,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(int.parse("0xffcccccc")),
                                      width: 5)),
                             child: Image.asset("images/${images[index]}",fit: BoxFit.fill,),
                            );
                          },
                        ),
                      ),
                    )
              ],
            ),
          ),
          Expanded(flex: 3,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ListView.builder(
                    itemExtent: 40,
                    itemCount: titles.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return  GestureDetector(
                        child: ClipRRect(
                          borderRadius: index==0?BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)):BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(index==0? int.parse("0xffaaaaaa"):int.parse("0xffffffff"),),
                              border: (index==0||index==5)? Border(bottom: BorderSide(color: Color(int.parse("0xffe5e8ee")),width: 0)):Border(bottom: BorderSide(color: Color(int.parse("0xffe5e8ee")),width: 2)),
                            ),
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child:
                            Text(titles[index],
                              style: TextStyle(color: Color(index==0?int.parse("0xfff9f9f9"): int.parse("0xff696969")),fontSize: index==0? 15:13,fontWeight: FontWeight.bold),
                            ),

                          ),
                        ),
                        onTap: (){
                            if(index>0){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return News();
                              },
                                    settings: RouteSettings(
                                    arguments: list[index-1],

                                  )
                              ));
                            }

                        },
                      );

                    },
                  ),
                ),
              ),
              Expanded(
                  flex:2,child: Container())
        ],
      ),
    ));
  }

}



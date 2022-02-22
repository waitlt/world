// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers





import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectAsset extends StatefulWidget {
  const SelectAsset({Key? key}) : super(key: key);

  @override
  _SelectAssetState createState() => _SelectAssetState();
}

class _SelectAssetState extends State<SelectAsset> {
  List assMaps=[];
  bool OK=false;
  String texts="text";
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );
    getAsset(index) async {
      String string="string";

      if(assMaps.length>0){
        assMaps.clear();
      }
      var response=await http.get(Uri.parse("http://10.0.2.2:5000/api/Asset/vague/${index}"));
      if(response.body.isEmpty){
        setState(() {
          OK=true;
        });
      }else {
        setState(() {
          OK=false;
          assMaps = json.decode(response.body.toString());
        });
      }

    }
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                        width: ScreenUtil().setWidth(300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        height: ScreenUtil().setHeight(30),
                        child: TextField(
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              )

                          ),
                          onChanged: (text){
                              getAsset(text);
                              setState(() {
                                texts=text;
                              });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: !OK,
                    child:  Container(
                      height: ScreenUtil().setHeight(332),
                      child:  ListView.builder(
                          shrinkWrap: true,
                          itemCount: assMaps.length>0? assMaps.length:1,
                          itemBuilder: (context,index){
                            // print(assMaps[index]["name"]);
                            // print(texts);

                            int indexs=assMaps.length>0? assMaps[index]["name"].toString().indexOf(texts):-1;
                            int ids=assMaps.length>0? assMaps[index]["assetNumber"].toString().indexOf(texts):-1;
                            int categorys=assMaps.length>0? assMaps[index]["category"].toString().indexOf(texts):-1;

                            // print(indexs);
                            // print("切割1"+assMaps[index]["name"].toString().substring(0,index));
                            // print("切割2"+assMaps[index]["name"].toString().substring(index,index+texts.length));
                            // print("切割3"+assMaps[index]["name"].toString().substring(index+texts.length,assMaps[index]["name"].toString().length));


                            return Container(
                              margin: EdgeInsets.only(top: 8),
                              color: Colors.white,
                              height: ScreenUtil().setHeight(100),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width: ScreenUtil().setWidth(90),
                                    height: ScreenUtil().setHeight(70),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color(int.parse("0xffcccccc")),width:assMaps.length>0? assMaps[index]["assetPhotos"].length>0? 5:0:0 )
                                    ),
                                    child: Image.asset("images/${assMaps.length>0? assMaps[index]["assetPhotos"].length>0? assMaps[index]["assetPhotos"][0]["photo"]:"none.png":"none.png"}",fit: BoxFit.fill,),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15,left: 20),
                                    width: ScreenUtil().setWidth(240),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: ScreenUtil().setWidth(240),
                                          child:Text.rich(TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: indexs!=-1? assMaps[index]["name"].toString().substring(0,indexs):assMaps.length>0? assMaps[index]["name"]:"Hydrapulper",
                                                  style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                                              ),
                                              TextSpan(
                                                  text: indexs!=-1? assMaps[index]["name"].toString().substring(indexs,indexs+texts.length):"",
                                                  style: TextStyle(color: Color(int.parse("0xffbb7b25")),fontWeight: FontWeight.bold)
                                              ),
                                              TextSpan(
                                                  text: indexs!=-1?assMaps[index]["name"].toString().substring(indexs+texts.length,assMaps[index]["name"].toString().length):"",
                                                  style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                                              ),
                                            ]
                                          ))
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 6),
                                          width: ScreenUtil().setWidth(240),
                                          child: Text.rich(TextSpan(
                                              children: [
                                                    TextSpan(
                                                        text: ids!=-1? assMaps[index]["assetNumber"].toString().substring(0,ids):assMaps.length>0? assMaps[index]["assetNumber"]:"01.0002",
                                                        style:TextStyle(color: Color(int.parse("0xff575757")),fontWeight: FontWeight.bold)
                                                    ),
                                                    TextSpan(
                                                        text: ids!=-1? assMaps[index]["assetNumber"].toString().substring(ids,ids+texts.length):"",
                                                        style: TextStyle(color: Color(int.parse("0xffbb7b25")),fontWeight: FontWeight.bold)
                                                    ),
                                                    TextSpan(
                                                         text: ids!=-1?assMaps[index]["assetNumber"].toString().substring(ids+texts.length,assMaps[index]["assetNumber"].toString().length):"",
                                                         style:TextStyle(color: Color(int.parse("0xff575757")),fontWeight: FontWeight.bold)
                                                    ),
                                                    ]
                                              ))
                                        ),
                                        // Text(assMaps.length>0? assMaps[index]["category"]:"Hydraulic",style: TextStyle(color: Color(int.parse("0xff575757")),fontWeight: FontWeight.bold),),
                                        Container(
                                          margin: EdgeInsets.only(top: 6),
                                          width: ScreenUtil().setWidth(240),
                                          child: Text.rich(TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: categorys!=-1? assMaps[index]["category"].toString().substring(0,categorys):assMaps.length>0? assMaps[index]["category"]:"Hydraulic",
                                                    style:TextStyle(color: Color(int.parse("0xff575757")),fontWeight: FontWeight.bold)
                                                ),
                                                TextSpan(
                                                    text: categorys!=-1? assMaps[index]["category"].toString().substring(categorys,categorys+texts.length):"",
                                                    style: TextStyle(color: Color(int.parse("0xffbb7b25")),fontWeight: FontWeight.bold)
                                                ),
                                                TextSpan(
                                                    text: categorys!=-1?assMaps[index]["category"].toString().substring(categorys+texts.length,assMaps[index]["category"].toString().length):"",
                                                    style:TextStyle(color: Color(int.parse("0xff575757")),fontWeight: FontWeight.bold)
                                                ),
                                              ]
                                          ))
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    )),
                Visibility(
                  visible: OK,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 20,left: 40),
                      child: Text("暂无查询到匹配资产",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                    )

                )


              ],
            ),
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )
        ));
  }
}

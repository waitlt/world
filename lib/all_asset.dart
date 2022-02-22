
// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'asset_details.dart';
import 'edit_asset.dart';
import 'select_asset.dart';
import 'people.dart';

class allAsset extends StatefulWidget {
  const allAsset({Key? key}) : super(key: key);

  @override
  _allAssetState createState() => _allAssetState();
}

class _allAssetState extends State<allAsset> {

  List assets=[];
  List sub_assets=[];
  int num=0;
  bool first=true;

  getAsset() async {
    var response=await http.get(Uri.parse("http://10.0.2.2:5000/api/Asset"));
    setState(() {
      if(response.statusCode==200){
        for(var item in json.decode(response.body)){
            assets.add(item);
        }
        assets.sort((left,right)=>left["name"]!.compareTo("${right["name"]}"));
        sub_assets=assets.sublist(0,6);
        assets.removeRange(0, 6);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAsset();
  }
  resume() async {
    var response=await http.get(Uri.parse("http://10.0.2.2:5000/api/Asset"));
    setState(() {
     if(assets.length>0){
       assets.clear();
       sub_assets.clear();
       for(var item in json.decode(response.body)){
         assets.add(item);
       }
       assets.sort((left,right)=>left["name"]!.compareTo("${right["name"]}"));
       var arguments = ModalRoute.of(context)!.settings.arguments;
       sub_assets=assets.sublist(0,int.parse(arguments.toString()));
       assets.removeRange(0, int.parse(arguments.toString()));
     }

   });
  }

  @override
  Widget build(BuildContext context) {

    if(first) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      if(arguments!=null) {
        resume();
      }
      first=false;
    }
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color(int.parse("0xfff2f2f2")),
          body:  Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: ScreenUtil().setHeight(40),
                  color: Color(int.parse("0xffd7d7d7")),
                  child:  Stack(
                    children: [
                      Align(
                        alignment: Alignment(-0.9, 0),
                        child: Text("Asset Management",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
                      ),
                      Align(
                        alignment: Alignment(0.7, 0),
                        child: InkWell(
                          child: Container(
                            width: ScreenUtil().setWidth(25),
                            height: ScreenUtil().setHeight(25),
                            child: Image.asset("images/icon-search.png"),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return  SelectAsset();
                            }));
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.9, 0),
                        child: InkWell(
                          child: Container(
                              width: ScreenUtil().setWidth(30),
                              height: ScreenUtil().setHeight(30),
                              child:  Image.asset("images/icon-mycenter.png")
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return People();
                            }));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: EasyRefresh(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: sub_assets.length>0? sub_assets.length:0,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, index>0? 5:0, 0, 0),
                                color: Colors.white,
                                height: ScreenUtil().setHeight(83),
                                width: MediaQuery.of(context).size.width,
                                child:Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment(-0.9,0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(int.parse("0xffcccccc")),
                                                width: sub_assets[index]["assetPhotos"].length>0? 5:0
                                            )
                                        ),
                                        width: ScreenUtil().setWidth(80),
                                        height: ScreenUtil().setHeight(55),
                                        child: Image.asset("images/${
                                            sub_assets[index]["assetPhotos"].length>0? sub_assets[index]["assetPhotos"][0]["photo"]:
                                            "none.png"

                                        }",fit: BoxFit.fill,),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(2.55,-0.60),
                                      child: Container(
                                        width: ScreenUtil().setWidth(300),
                                        child: Text(sub_assets[index]["name"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                    Align(
                                      child:  Container(
                                        alignment: Alignment(-0.4,-0.05),
                                        width: ScreenUtil().setWidth(300),
                                        child: Text(sub_assets[index]["assetNumber"]),
                                      ),
                                    ),
                                    Align(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 38, 0, 0),
                                        height:ScreenUtil().setHeight(20),
                                        width: ScreenUtil().setWidth(150),
                                        child: Text(sub_assets[index]["category"],textAlign: TextAlign.start,),
                                      ),
                                    ),

                                        Align(
                                        alignment: Alignment(0.9, 0.6),
                                        child: InkWell(
                                          child: Container(
                                            width: ScreenUtil().setWidth(25),
                                            height: ScreenUtil().setHeight(25),
                                            child: Image.asset("images/icon-edit.png"),
                                          ),
                                          onTap: (){
                                            num=sub_assets.length;
                                            print(num);
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context){
                                              return EditAsset();
                                            },
                                              settings: RouteSettings(
                                                name: num.toString(),
                                                arguments: sub_assets[index]
                                              )

                                            ));
                                          },
                                        ),
                                      ),




                                  ],
                                ),
                              ),
                              onTap: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (context){
                                        return AssetDetails();
                                    },
                                      settings: RouteSettings(
                                        arguments: sub_assets[index]
                                      )

                                    ),
                                    );
                              },
                            );
                          },
                          ),
                      footer: PhoenixFooter(),

                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 2), () {

                          setState(() {
                            if(assets.length>6) {
                              assets.sublist(0, 6).forEach((element) {
                                sub_assets.add(element);
                              });
                              assets.removeRange(0, 6);
                            }else{
                              if(assets.length>0){
                                assets.sublist(0,assets.length).forEach((element) {
                                  sub_assets.add(element);
                                });
                                assets.removeRange(0, assets.length);
                              }else{
                                Fluttertoast.showToast(msg: "所有资产已加载完毕!");
                              }
                            }
                          });


                        });
                      },
                    )),
                      SizedBox(height: ScreenUtil().setHeight(23),),
                      InkWell(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(275, 0, 0, 20),
                            width: ScreenUtil().setWidth(60),
                            height: ScreenUtil().setHeight(60),
                            child:  Image.asset("images/icon-add-2.png",color: Colors.grey,)
                        ),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context){
                            return EditAsset();
                          }
                          ));
                        },
                      )
                      ,



              ],
            ),
          ),
        );
  }
}
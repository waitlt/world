import 'dart:convert';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetDetails extends StatefulWidget {
  const AssetDetails({Key? key}) : super(key: key);

  @override
  _AssetDetailsState createState() => _AssetDetailsState();
}

class _AssetDetailsState extends State<AssetDetails> {


  @override
  Widget build(BuildContext context) {
    List keys=[];
    List values=[];
    List images=[];
    DateFormat format=DateFormat("yyyy-MM-dd");
    Object? arguments = ModalRoute.of(context)!.settings.arguments;
    Map assetMap=json.decode(json.encode(arguments));
    if(assetMap["assetPhotos"].length>0) {
      Map map = json.decode(assetMap["specification"]);
      map.forEach((key, value) {
        keys.add(key);
        values.add(value);
      });
    }

    images=assetMap["assetPhotos"];

    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );
    return SafeArea(
        child:Scaffold(
          body: Container(
            color: Color(int.parse("0xfff2f2f2")),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: ScreenUtil().setHeight(40),
                  color: Color(int.parse("0xffd7d7d7")),
                  child: Stack(
                    children: [
                     Align(
                       alignment: Alignment(-0.95,0),
                       child: InkWell(
                         child: Container(
                           width: ScreenUtil().setWidth(25),
                           height: ScreenUtil().setHeight(25),
                           child: Image.asset("images/icon-left.png",fit: BoxFit.fill,),
                         ),
                         onTap: (){
                           Navigator.pop(context);
                         },
                       )
                     ),
                      Align(
                        alignment: Alignment(-0.75,0),
                        child: Text("View Asset",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                      ),
                      Align(
                        alignment: Alignment(0.90,0),
                        child: InkWell(
                          child: Image.asset("images/icon-edit.png",width: ScreenUtil().setWidth(25),height: ScreenUtil().setHeight(25),),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                       Container(
                         margin: EdgeInsets.all(10),
                         child:  Row(
                           children: [
                             Text("Name: ",style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13)),
                             Text(assetMap["name"],style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),)
                           ],
                         ),
                       ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          child: Row(
                            children: [
                              Text("Asset Category: ",style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),
                              Container(
                                width: ScreenUtil().setWidth(126),
                                child:Text(assetMap["category"],style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),
                              ),

                              Text("price: ",style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 14),),
                              Text(assetMap["price"].toString(),style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),

                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          child: Row(
                            children: [
                              Text("Manufacture Date: ",style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),
                              Text(format.format(DateTime.parse(assetMap["manufactureDate"])),style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),
                              Container(
                                margin: EdgeInsets.fromLTRB(58, 0, 0, 0),
                                child: Text("Service Date: ",style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),
                              ),
                              Text(assetMap["serviceDate"]==null? "无":format.format(DateTime.parse(assetMap["serviceDate"])),style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),

                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0,10),
                          child: Row(
                            children: [
                              Text("Department: ",style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),
                              Text(assetMap["department"],style: TextStyle(color: Color(int.parse("0xff5b5b5b")),fontWeight: FontWeight.bold,fontSize: 13),),
                            ],
                          ),
                        ),
                        Container(
                          color: Color(int.parse("0xffd7d7d7")),
                          height: ScreenUtil().setHeight(6),
                          width: MediaQuery.of(context).size.width,
                        )
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              height: ScreenUtil().setHeight(227),
                              child: ListView.builder(
                                  itemCount: keys.length,
                                  itemExtent: 45,
                                  itemBuilder:(context,index){
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Color(int.parse("0xffe4e9ef")))
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: ScreenUtil().setWidth(120),
                                            height: ScreenUtil().setHeight(43),
                                            padding: EdgeInsets.fromLTRB(0, 0, index==4? 97:7, 0),
                                            alignment: Alignment.centerRight,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(color: Color(int.parse("0xffe4e9ef")))
                                                )
                                            ),
                                            child: Text(index==4? "......": keys[index],style: TextStyle(color: Color(index==4? int.parse("0xffb8b8b8"):int.parse("0xff606060")),fontWeight: FontWeight.bold),),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
                                            child: Text(index==4? "......": values[index],style: TextStyle(color: Color(index==4? int.parse("0xffb8b8b8"):int.parse("0xff606060")),fontWeight: FontWeight.bold),),
                                          )
                                          //Text("data")
                                        ],
                                      ),
                                    );
                                  }

                              ),
                            ),
                            Container(
                                margin: EdgeInsets.fromLTRB(30, 20, 0, 0),
                                child: Visibility(
                                  visible: assetMap["assetPhotos"].length>0? false:true,
                                  child: Text("暂无资产规格信息",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                )
                            )
                            
                          ],
                        ),
                        Spacer(),
                        Container(
                          color: Color(int.parse("0xffd7d7d7")),
                          height: ScreenUtil().setHeight(6),
                          width: MediaQuery.of(context).size.width,
                        )


                      ],
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.7
                      ),
                      itemCount: images.length,
                      itemBuilder: (context,index){
                        return Container(
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setHeight(200),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(int.parse("0xffcccccc")),width: 5)
                          ),
                          child: Image.asset("images/${images[index]["photo"]}",fit: BoxFit.fill,),
                        );
                      }),
                ),
                        Container(
                            margin: EdgeInsets.fromLTRB(30, 20, 0, 0),
                            child: Visibility(
                              visible: assetMap["assetPhotos"].length>0? false:true,
                              child: Text("暂无资产照片信息",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                            )
                        )
                      ],
                    )),
              ],
            ),
          ),

        )

    );
  }
}

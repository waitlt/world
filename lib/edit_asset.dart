// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'all_asset.dart';
import 'package:sizer/sizer.dart';
import 'edit_asset_horizontal.dart';

class EditAsset extends StatefulWidget {
  const EditAsset({Key? key}) : super(key: key);

  @override
  _EditAssetState createState() => _EditAssetState();
}

class _EditAssetState extends State<EditAsset> {
  static final TextEditingController assetName=TextEditingController();
  static final TextEditingController Price=TextEditingController();
  List categoryList=[];
  List<PopupMenuItem> categoryItems=[];
  List<PopupMenuItem> departmentItems=[];
  List<PopupMenuItem> AttributeNameItems=[];
  List<PopupMenuItem> AttributeValueItems=[];
  List Attributes=[];
  List departmentList=[];
  List AttributeName=[];
  String number="Asset Number";
  String Category="Select Asset Category";
  int CategoryId=0;
  int DepartmentId=0;
  int id=0;
  String Department="Department";
  String initialDates="Manufacture Date";
  String ServiceDate="Service Date";
  String attributeName="Attribute Name";
  String attributeValue="Attribute Value";
  bool first=true;
  XFile? image;
  Object? arguments;
  Map assetMap={};
  List deleteImages=[];
  bool _OK=true;
  XFile? file;
  List images=[];
  bool only=false;
  bool ER=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
    getDepartment();

  }
  getCategory() async {
    var response=await http.get(Uri.parse("http://10.0.2.2:5000/api/AssetCategory"));
    categoryList=json.decode(response.body.toString());
  }
  getDepartment() async {
    var response=await http.get(Uri.parse("http://10.0.2.2:5000/api/Department"));
    departmentList=json.decode(response.body.toString());
    setState(() {
      Department=departmentList[assetMap["departmentId"]-1]["name"].toString();
    });

  }
  getNum(index) async {
    var response= await http.get(Uri.parse("http://10.0.2.2:5000/api/Asset/${index}"));
    setState(() {
      number=json.decode(response.body)["proposal"];
    });
  }
  getTime() async {
    DateFormat format=DateFormat("yyyy-MM-dd");
    var result=await showDatePicker(
        context: context,
        initialDate:DateTime.parse(initialDates=="Manufacture Date"?  DateTime.now().toString():initialDates) ,
        firstDate: DateTime(1978),
        lastDate: DateTime(2021,12,31),
        currentDate:DateTime.parse(initialDates=="Manufacture Date"?  DateTime.now().toString():initialDates)
    );
    setState(() {
      initialDates=format.format(result!);
    });
  }
  getAttributeName(index) async {
      if(index!=5){
        var response=await http.get(Uri.parse("http://10.0.2.2:5000/api/AssetattributeKey/${index}"));
        List list=json.decode(response.body);
        if(AttributeName.length>0){
          AttributeName.clear();
        }
        list.forEach((element) {
          AttributeName.add(element);
        });

      }else{
        if(AttributeName.length>0){
          AttributeName.clear();
        }
      }
  }
  getAttributeValue(index){
    AttributeName.forEach((element) async {
      if(index==element["name"]){
        print(element["name"]);
        print(element["categoryId"]);
        var response=await http.get(Uri.parse("http://10.0.2.2:5000/api/AssetAttributeValue/${element["categoryId"]}"));
        List values=json.decode(response.body);
        if(AttributeValueItems.length>0){
          AttributeValueItems.clear();
        }
        values.forEach((element) {
          AttributeValueItems.add(new PopupMenuItem(
              child: Text(element["value"]),height: 40,value: element["value"],));
        });
      }
    });
  }
  deleteImage(index) async {
    await http.post(Uri.parse("http://10.0.2.2:5000/api/AssetPhoto/DeleteAssetPhoto"),
        headers:{"content-type" : "application/json"},
        body:json.encode({"Id": deleteImages[index]["id"].toString(),"AssetId": deleteImages[index]["assetId"].toString()}) );
  }
  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(builder: (context,state){
              return  Container(
                height: assetMap["assetPhotos"].length>0? ScreenUtil().setHeight(500):ScreenUtil().setHeight(110),
                child: Column(
                  children: [
                    Visibility(
                        child: Container(
                          height: ScreenUtil().setHeight(100),
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 120,
                                mainAxisExtent: 90,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10
                            ),
                            itemCount: deleteImages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Stack(
                                  children: [
                                    Align(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey,width: 5)
                                        ),
                                        height: ScreenUtil().setHeight(80),
                                        width: ScreenUtil().setWidth(100),
                                        child: Image.asset("images/${deleteImages[index]["photo"]}",fit: BoxFit.fill,),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment(1.3,-1.1),
                                      child:InkWell(
                                        child:  Container(
                                          width: ScreenUtil().setWidth(25),
                                          height: ScreenUtil().setHeight(25),
                                          child: Image.asset("images/icon-delete.png",fit: BoxFit.fill,),
                                        ),
                                        onTap: (){
                                          state((){
                                            deleteImage(index);
                                            deleteImages.removeAt(index);
                                            setState(() {
                                              images.removeAt(index);
                                            });
                                          });
                                          //deleteImage(index);
                                        },
                                      ),
                                    ) ,
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    visible: assetMap["assetPhotos"].length>0? true:false,
                    )
                    ,
                    Visibility(child: Spacer(),
                      visible: assetMap["assetPhotos"].length>0? true:false,
                    ),

                    Container(
                      child:  Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin: assetMap["assetPhotos"].length>0? EdgeInsets.only(top:50):EdgeInsets.only(top:15),
                              padding: EdgeInsets.only(top: 5),
                              height: ScreenUtil().setHeight(30),
                              child: CreateItem(true, "相机"),
                            ),
                            Divider(color: Colors.black,),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              height: ScreenUtil().setHeight(30),
                              child: CreateItem(false, "相册"),
                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              );
          });
    });


  }
   Widget CreateItem(bool state,String name){
    return GestureDetector(
      child:  Text(name,textAlign: TextAlign.center,),
      onTap: (){
        openPicter(state);
      },
    );
  }
  openPicter(bool state) async {
    Navigator.pop(context);
    var _picker = ImagePicker();
    file=(await _picker.pickImage(source: state? ImageSource.camera:ImageSource.gallery));
    setState(() {
        image=file;
    });
    // String path=file!.path.toString();
    // print(file!.path is Null);
    // var response=await http.post(Uri.parse("http://10.0.2.2:5000/api/AssetPhoto/AddAssetPhoto"),
    // headers:{"content-type" : "application/json"},
    // body: json.encode({
    //   "AssetId":assetMap["id"].toString(),
    //   "photo":path
    // })
    // );
    //
    // print(response.statusCode);
    // print(response.body);
  }


  
  @override
  Widget build(BuildContext context) {

    if(MediaQuery.of(context).orientation==Orientation.landscape){
      Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(
              name: jsonEncode(assetMap),
              arguments: {
                "Category":Category,
                "AssetName":assetName.text,
                "Department":Department,
                "Price":Price.text,
                "initialDates":initialDates,
                "ServiceDate":ServiceDate,
                "number":number,
                "CategoryId":CategoryId
              }
          ),
          builder: (context){
            return EditAssetHorizontal();
          }));
    }


    DateFormat format = DateFormat("yyyy-MM-dd");
    arguments = ModalRoute.of(context)!.settings.arguments;
    if(arguments!=null) {
      ER=true;
      assetMap= json.decode(json.encode(arguments));
      DateFormat format = DateFormat("yyyy-MM-dd");
      if (first) {
        CategoryId=assetMap["categoryId"];
        DepartmentId=assetMap["departmentId"];
        initialDates =
            format.format(DateTime.parse(assetMap["manufactureDate"]));
        ServiceDate = format.format(assetMap["serviceDate"]!=null? DateTime.parse(assetMap["serviceDate"]):DateTime.now());
        number=assetMap["assetNumber"];
        Category=assetMap["category"];
        if(assetMap["specification"]!=Null){
          Map map=json.decode(assetMap["specification"]);
          map.forEach((key, value) {
            Attributes.add({
              "name": key,
              "value": value,
            });
          });
        }
        List list = json.decode(json.encode(assetMap["assetPhotos"]));
        list.forEach((element) {
          images.add(element["photo"]);
        });
        getAttributeName(assetMap["categoryId"]);
        id=assetMap["id"];
        if (assetMap["assetPhotos"].length > 0) {
          List list=assetMap["assetPhotos"];
          list.forEach((element) {
            deleteImages.add(element);
          });
        }
        first = false;
      }
    }else{
      ER=false;
    }
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );
    return SafeArea(
        child:Scaffold(
          resizeToAvoidBottomInset: false,
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
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
                                  assetName.clear();
                                  Price.clear();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    settings: RouteSettings(
                                      arguments: ModalRoute.of(context)!.settings.name
                                    ),
                                      builder: (context){
                                     return allAsset();
                                  }));
                                },
                              )
                          ),
                          Align(
                            alignment: Alignment(-0.75,0),
                            child: Text("Register / Edit Asset",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          ),
                          Align(
                            alignment: Alignment(0.90,0),
                            child: InkWell(
                              child: Image.asset("images/icon-submit.png",width: ScreenUtil().setWidth(30),height: ScreenUtil().setHeight(30),fit: BoxFit.cover,),
                              onTap: () async {
                                print("id:${id}");
                                print("Asset Category:${CategoryId}");
                                print("Asset Name:${assetName.text}");
                                print("Department:${DepartmentId}");
                                print("Price:${Price.text}");
                                print("Manufacture Date:${initialDates}");
                                print("Service Date:${ServiceDate}");
                                print("Asset Number:${number}");

                                if((CategoryId)!=assetMap["categoryId"]||(assetName.text!="")||(DepartmentId!=assetMap["departmentId"])||(Price.text!="")||(initialDates!=assetMap["manufactureDate"])||(ServiceDate!=assetMap["serviceDate"])||Attributes.length>0){

                                       if(ER) {
                                         Map map = {};
                                         Attributes.forEach((element) {
                                           map.putIfAbsent(element["name"], () => element["value"]);
                                         });
                                         print("map${map}");
                                         var response = await http.post(
                                             Uri.parse(
                                                 "http://10.0.2.2:5000/api/Asset/UpdateAsset"),
                                             headers: {
                                               "content-type": "application/json"
                                             },
                                             body: json.encode({
                                               "id": assetMap["id"],
                                               "name": assetName.text == "" ? assetMap["name"] : assetName.text,
                                               "assetNumber": number == "Asset Number" ? assetMap["assetNumber"] : number,
                                               "categoryId": CategoryId == assetMap["categoryId"] ? assetMap["categoryId"] : CategoryId,
                                               "departmentId": DepartmentId == assetMap["departmentId"] ? assetMap["departmentId"] : DepartmentId,
                                               "price": Price.text == "" ? assetMap["price"] : Price.text,
                                               "manufactureDate": initialDates == assetMap["manufactureDate"] ? assetMap["manufactureDate"] : initialDates,
                                               "serviceDate": ServiceDate == assetMap["serviceDate"] ? assetMap["serviceDate"] : ServiceDate,
                                               "registrationTime": null,
                                               "specification": json.encode(map)
                                             })
                                         );
                                         assetName.clear();
                                         Price.clear();
                                         if (response.statusCode == 200) {
                                           Fluttertoast.showToast(
                                               msg: "资产信息更新成功!");
                                           Navigator.of(context).push(
                                               MaterialPageRoute(
                                                   builder: (context) {
                                                     return allAsset();
                                                   }));
                                         } else {
                                           Fluttertoast.showToast(
                                               msg: response.body);
                                         }

                                       }else {
                                         if ((CategoryId) != 0 && (assetName.text != "") && (DepartmentId != 0) && (Price.text != "") &&(initialDates !="Manufacture Date") &&(ServiceDate != "Service Date")) {
                                           Map map = {};
                                           Attributes.forEach((element) {
                                             map.putIfAbsent(element["name"], () => element["value"]);
                                           });
                                           DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");
                                           print("Asset Category:${CategoryId}");
                                           print("Asset Name:${assetName.text}");
                                           print("Department:${DepartmentId}");
                                           print("Price:${Price.text}");
                                           print("Manufacture Date:${initialDates}");
                                           print("Service Date:${ServiceDate}");
                                           print("Asset Number:${number}");
                                           print(format.format(DateTime.now()));
                                           print(map);

                                           var response = await http.post(
                                               Uri.parse("http://10.0.2.2:5000/api/Asset/AddAsset"),
                                               headers: {"content-type": "application/json"
                                               },
                                               body: json.encode({
                                                 "name":assetName.text,
                                                 "assetNumber": number,
                                                 "categoryId": json.encode(CategoryId) ,
                                                 "departmentId": json.encode(DepartmentId),
                                                 "price":Price.text,
                                                 "manufactureDate": initialDates,
                                                 "serviceDate": ServiceDate,
                                                 "registrationTime": format.format(DateTime.now()),
                                                 "specification": json.encode(map)
                                               })
                                           );
                                           assetName.clear();
                                           Price.clear();
                                           if (response.statusCode == 200) {
                                             Fluttertoast.showToast(
                                                 msg: "资产添加成功!");
                                             Navigator.of(context).push(
                                                 MaterialPageRoute(
                                                     builder: (context) {
                                                       return allAsset();
                                                     }));
                                           } else {
                                             Fluttertoast.showToast(
                                                 msg: response.body);
                                             print(response.body);
                                           }
                                         }else{
                                           Fluttertoast.showToast(msg: "资产信息填写不完整");
                                         }
                                       }
                                }else{
                                  Fluttertoast.showToast(msg: "未更改任何信息!");
                                }


                              },
                            ),

                          )
                        ],
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(35),
                      margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child:  Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            color: Color(int.parse("0xffd7d7d7")),
                            height: ScreenUtil().setHeight(40),
                            width: ScreenUtil().setWidth(10),
                          ),
                          Text("Basic Informaction",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(17, 10, 0, 0),
                      child: Row(
                        children: [
                          Container(
                              width: ScreenUtil().setWidth(290),
                              child:Text(Category,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),   
                          ),
                          Container(
                            child: PopupMenuButton(
                              itemBuilder: (context){
                                if(categoryItems.length>0){
                                  categoryItems.clear();
                                }
                                categoryList.forEach((element) {
                                  categoryItems.add(new PopupMenuItem(child: Text(element["name"]),height: 40,value: element["id"],));
                                });
                                return categoryItems;
                              },
                              onSelected: (index){
                                getAttributeName(index);
                                int id=int.parse(index.toString());
                                getNum(index);
                                  setState(()  {
                                      Category=categoryList[id-1]["name"];
                                      CategoryId=id;
                                  });
                              },
                              child:
                              Icon(Icons.arrow_drop_down,size: 28,color: Color(int.parse("0xff7f7f7f")),),
                            ),
                          )

                        ],
                      ),
                    ),//   Category
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setHeight(1),
                        color: Color(int.parse("0xffd6d6d6"),
                        )
                    ),//下划线
                    Container(
                        height: ScreenUtil().setHeight(30),
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(17,0, 13, 5),
                        child: TextField(
                          controller: assetName,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(int.parse("0xffd6d6d6")))
                            ),
                            hintStyle: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),
                            hintText:assetMap.length>0? assetMap["name"]:"Asset Name",
                          ),
                          style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),

                        )
                    ),//AssetName
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(17, 0, 0, 0),
                        child: Row(
                          children: [
                           Container(
                             height: ScreenUtil().setHeight(35),
                             child:  Column(
                               children: [
                                 Container(
                                   margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                   width: ScreenUtil().setWidth(166),
                                   child: Row(
                                     children: [
                                       Container(
                                         width: ScreenUtil().setWidth(140),
                                         child: Text(Department,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                       ),
                                       Container(
                                         child: PopupMenuButton(
                                           itemBuilder: (context){
                                             if(departmentItems.length>0){
                                               departmentItems.clear();
                                             }
                                             departmentList.forEach((element) {
                                               departmentItems.add(new PopupMenuItem(child: Text(element["name"]),height: 40,value: element["id"],));
                                             });
                                             return departmentItems;
                                           },
                                           child:
                                           Icon(Icons.arrow_drop_down,size: 28,color: Color(int.parse("0xff7f7f7f")),),
                                           onSelected: (name){
                                             setState(() {
                                               Department=departmentList[int.parse(name.toString())-1]["name"].toString();
                                               DepartmentId=int.parse(name.toString());
                                             });

                                           },
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),

                                 Container(
                                     margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                     width: ScreenUtil().setWidth(154),
                                     height: ScreenUtil().setHeight(1),
                                     color: Color(int.parse("0xffd6d6d6"),
                                     )
                                 ),
                               ],
                             ),
                           ),
                           Container(
                             width: ScreenUtil().setWidth(148),
                             height: ScreenUtil().setHeight(28),
                             child: TextField(
                               controller: Price,
                               decoration: InputDecoration(
                                 enabledBorder: UnderlineInputBorder(
                                     borderSide: BorderSide(color: Color(int.parse("0xffd6d6d6")))
                                 ),
                                 hintStyle: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),
                                 hintText:assetMap.length>0? assetMap["price"].toString():"Price",
                               ),
                                 style:TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),

                             ),
                           )
                          ],
                        )
                    ),//department price
                    Container(
                      alignment: Alignment.topLeft,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Row(
                        children: [
                           Column(
                              children: [
                               Container(
                                 height: ScreenUtil().setHeight(30),
                                   width: ScreenUtil().setWidth(175),
                                 child:  Row(
                                   children: [
                                     Container(
                                       width: ScreenUtil().setWidth(135),
                                       margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                       child: Text(initialDates,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                     ),
                                     InkWell(
                                       child: Container(
                                         width: ScreenUtil().setWidth(25),
                                         height: ScreenUtil().setHeight(25),
                                         child: Image.asset("images/icon-calendar.png"),
                                       ),
                                       onTap: ()   {
                                         getTime();
                                       }
                                       ,
                                     )

                                   ],
                                 )
                               ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 7, 20, 0),
                                    width: ScreenUtil().setWidth(157),
                                    height: ScreenUtil().setHeight(1),
                                    color: Color(int.parse("0xffd6d6d6"),
                                    )
                                ),
                              ],
                            ),
                          Column(
                            children: [
                              Container(
                                  height: ScreenUtil().setHeight(30),
                                  width: ScreenUtil().setWidth(170),
                                  child:  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(8, 5, 0, 0),
                                        child: Text(ServiceDate,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                      ),
                                      SizedBox(width: 69,),
                                      InkWell(
                                        child:  Container(
                                          width: ScreenUtil().setWidth(25),
                                          height: ScreenUtil().setHeight(25),
                                          child: Image.asset("images/icon-calendar.png"),
                                        ),
                                        onTap: () async {
                                          var result=await showDatePicker(
                                              context: context,
                                              initialDate:DateTime.parse(ServiceDate=="Service Date"?  DateTime.now().toString():ServiceDate) ,
                                              firstDate: DateTime(1978),
                                              lastDate: DateTime(2021,12,31),
                                              currentDate:DateTime.parse(ServiceDate=="Service Date"?  DateTime.now().toString():ServiceDate)
                                          );
                                          setState(() {
                                            ServiceDate=format.format(result!);
                                          });
                                        },
                                      )

                                    ],
                                  )
                              ),
                               Container(
                                    margin: EdgeInsets.fromLTRB(0, 7,10, 0),
                                    width: ScreenUtil().setWidth(151),
                                    height: ScreenUtil().setHeight(1),
                                    color: Color(int.parse("0xffd6d6d6"),
                                    )
                                ),



                            ],
                          ),



                        ],
                      ),
                    ),//Date
                    Container(
                      margin: EdgeInsets.fromLTRB(17, 0, 0, 0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width:  ScreenUtil().setWidth(157),
                                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Text(number,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                  )

                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  width: ScreenUtil().setWidth(157),
                                  height: ScreenUtil().setHeight(1),
                                  color: Color(int.parse("0xffd6d6d6"),
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),//assetNum
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width:MediaQuery.of(context).size.width,
                        height: ScreenUtil().setHeight(7),
                        color: Color(int.parse("0xffd6d6d6"),
                        )
                    ),
                    Container(
                      height: ScreenUtil().setHeight(35),
                      margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child:  Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            color: Color(int.parse("0xffd7d7d7")),
                            height: ScreenUtil().setHeight(40),
                            width: ScreenUtil().setWidth(10),
                          ),
                          Text("Specification",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      // width: ScreenUtil().setWidth(178),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                                            width: ScreenUtil().setWidth(155),
                                            child: Text(attributeName,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                          ),
                                          Container(
                                            child: PopupMenuButton(
                                              itemBuilder: (context){
                                                if(AttributeNameItems.length>0){
                                                  AttributeNameItems.clear();
                                                }
                                                AttributeName.forEach((element) {
                                                    AttributeNameItems.add(new PopupMenuItem(
                                                        child:Text(element["name"]),height: 40,value: element["name"],));
                                                });
                                                return AttributeNameItems;
                                              },
                                              child:
                                              Icon(Icons.arrow_drop_down,size: 27,color: Color(int.parse("0xff7f7f7f")),),
                                              onSelected: (index){
                                                  setState(() {
                                                    attributeName=index.toString();
                                                    getAttributeValue(index);
                                                  });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        width: ScreenUtil().setWidth(164),
                                        height: ScreenUtil().setHeight(1),
                                        color: Color(int.parse("0xffd6d6d6"),
                                        )
                                    ),
                                  ],
                                ),
                              ),),
                          Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      width: ScreenUtil().setWidth(178),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                                            width: ScreenUtil().setWidth(148),
                                            child: Text(attributeValue,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                          ),
                                          Container(
                                            child: PopupMenuButton(
                                              itemBuilder: (context){
                                                return AttributeValueItems;
                                              },
                                              child:
                                              Icon(Icons.arrow_drop_down,size: 27,color: Color(int.parse("0xff7f7f7f")),),
                                              onSelected: (index){
                                                setState(() {
                                                  attributeValue=index.toString();
                                                });

                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        width: ScreenUtil().setWidth(164),
                                        height: ScreenUtil().setHeight(1),
                                        color: Color(int.parse("0xffd6d6d6"),
                                        )
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),//Attribute Name
                    InkWell(
                      child: Container(
                        width: ScreenUtil().setWidth(70),
                        height: ScreenUtil().setHeight(25),
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(310, 10, 0, 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(int.parse("0xff656565")),width: 1)
                        ),
                        child: Text("Add to list",style: TextStyle(color: Color(int.parse("0xff808080"))),),
                      ),
                      onTap: (){
                        _OK=true;
                        if(attributeName!="Attribute Name") {
                          if(attributeValue=="Attribute Value"){
                            Fluttertoast.showToast(msg: "资产规格详情不能为空");
                          }else {
                            if (Attributes.length > 0) {
                              print(Attributes.length);
                              Attributes.forEach((element) {
                                print("便利${element["name"]}");
                                if(attributeName==element["name"]){
                                  // print("选中的name:${attributeName}");
                                  // print("已有的name:${element["name"]}");
                                  Fluttertoast.showToast(
                                     msg: "资产规格名称不能相同！",
                                  );
                                  _OK=false;
                                }
                              });
                              if(_OK){
                                setState(() {
                                  Attributes.add({
                                    "name": attributeName,
                                    "value": attributeValue,
                                  });
                                });
                              }
                            }else{
                              setState(() {
                                Attributes.add({
                                  "name": attributeName,
                                  "value": attributeValue,
                                });
                              });
                            }
                          }

                        }else{
                          Fluttertoast.showToast(msg: "暂无资产规格信息");
                        }
                      },
                    ),
                    Container(
                      height: ScreenUtil().setHeight(120),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child:  ListView.builder(
                          shrinkWrap: true,
                          itemCount:Attributes.length,
                          itemExtent: 35,
                          itemBuilder: (context,index){
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(int.parse("0xffb3b3b3")),width:1)
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width: ScreenUtil().setWidth(110),
                                    child: Text(Attributes[index]["name"],style: TextStyle(color: Color(int.parse("0xff3c3d3d")),fontSize: 13),),
                                  ),
                                  Container(
                                    child: Text("/",style: TextStyle(color: Color(int.parse("0xff3c3d3d")),fontSize: 13),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    width: ScreenUtil().setWidth(160),
                                    child: Text(Attributes[index]["value"],style: TextStyle(color: Color(int.parse("0xff3c3d3d")),fontSize: 13),),
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: ScreenUtil().setWidth(22),
                                      height:ScreenUtil().setHeight(22),
                                      child: Image.asset("images/icon-delete.png",color: Color(int.parse("0xff999999")),),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        Attributes.removeAt(index);
                                      });
                                    },
                                  )

                                ],
                              ),
                            );
                          }),
                    ),//List
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        width:MediaQuery.of(context).size.width,
                        height: ScreenUtil().setHeight(7),
                        color: Color(int.parse("0xffd6d6d6"),
                        )
                    ),
                    Container(
                      height: ScreenUtil().setHeight(35),
                      margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child:  Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            color: Color(int.parse("0xffd7d7d7")),
                            height: ScreenUtil().setHeight(40),
                            width: ScreenUtil().setWidth(10),
                          ),
                          Text("Photo",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child:  Row(
                        children: [
                          SizedBox(height: ScreenUtil().setHeight(90),),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(int.parse("0xffcccccc")),width: images.length>0? 5:0)
                            ),
                            width: ScreenUtil().setWidth(110),
                            height: ScreenUtil().setHeight(75),
                            child: Image.asset("images/${images.length>0? images[0]:"none.png"}",fit: BoxFit.fill,),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(int.parse("0xffcccccc")),width: image==null? 0:5)
                            ),
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            width: ScreenUtil().setWidth(110),
                            height: ScreenUtil().setHeight(75),
                            child: image==null? Image.asset("images/none.png",fit: BoxFit.fill,):Image.file(new File(image!.path),fit: BoxFit.fill,),
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 41, 0, 0),
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setHeight(45),
                              child: Image.asset("images/icon-add.png",fit: BoxFit.fill,color: Color(int.parse("0xffaaaaaa")),),
                            ),
                            onTap: () {
                               showPicker();
                            },
                          )

                        ],
                      ),
                    )
                  ],
                ),
              ),
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
        ));


  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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


class EditAssetHorizontal extends StatefulWidget {
  const EditAssetHorizontal({Key? key}) : super(key: key);

  @override
  _EditAssetHorizontalState createState() => _EditAssetHorizontalState();
}

class _EditAssetHorizontalState extends State<EditAssetHorizontal> {
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
  Object? Editarguments;
  Map assetMap={};
  Map EditMap={};
  List deleteImages=[];
  bool _OK=true;

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
      //Department=departmentList[assetMap["departmentId"]-1]["name"].toString();
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
    XFile? file=(await _picker.pickImage(source: state? ImageSource.camera:ImageSource.gallery));
    Image image=Image.file(new File(file!.path));

    setState(() {
      //image=file;
      // print(image!.name);
      // print(image!.path);

    });
  }
  @override
  Widget build(BuildContext context) {


    DateFormat format = DateFormat("yyyy-MM-dd");
    arguments = ModalRoute.of(context)!.settings.name;
    Editarguments=ModalRoute.of(context)!.settings.arguments;
    if(arguments!=null) {
      print(arguments.toString());
      String jd=arguments.toString();
      assetMap= jsonDecode(jd);
      EditMap=json.decode(json.encode(Editarguments));
      DateFormat format = DateFormat("yyyy-MM-dd");
      if (first) {
        initialDates =
            format.format(DateTime.parse(EditMap["initialDates"]));
        ServiceDate = format.format(DateTime.parse(EditMap["ServiceDate"]));
        number=EditMap["number"];
        Category=EditMap["Category"];
        Map map=json.decode(assetMap["specification"]);
        map.forEach((key, value) {
          Attributes.add({
            "name": key,
            "value": value,
          });
        });
        if(EditMap["CategoryId"]>0){
          getAttributeName(EditMap["CategoryId"]);
        }
        id=assetMap["id"];
        if (assetMap["assetPhotos"].length > 0) {
          List list=assetMap["assetPhotos"];
          list.forEach((element) {
            deleteImages.add(element);
          });
        }
        first = false;
      }
    }
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
    );
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
          behavior: HitTestBehavior.translucent,
            onTap: (){
              FocusScope.of(context).requestFocus(FocusNode());
            },
          child: Container(
            color: Color(int.parse("0xfff2f2f2")),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: ScreenUtil().setHeight(50),
                  color: Color(int.parse("0xffd7d7d7")),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment(-0.95,0),
                          child: InkWell(
                            child: Container(
                              width: ScreenUtil().setWidth(15),
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
                        child: Text("Register / Edit Asset",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                      ),
                      Align(
                        alignment: Alignment(0.90,0),
                        child: InkWell(
                          child: Image.asset("images/icon-submit.png",width: ScreenUtil().setWidth(20),height: ScreenUtil().setHeight(50),fit: BoxFit.fill,),
                          onTap: () async {
                            print("id:${id}");
                            print("Asset Category:${CategoryId+1}");
                            print("Asset Name:${assetName.text}");
                            print("Department:${DepartmentId}");
                            print("Price:${Price.text}");
                            print("Manufacture Date:${initialDates}");
                            print("Service Date:${ServiceDate}");
                            print("Asset Number:${number}");
                            if((CategoryId+1)!=assetMap["categoryId"]||(assetName.text!=assetMap["name"])||(DepartmentId==assetMap["departmentId"])||(Price.text!=assetMap["price"])||(initialDates!=assetMap["manufactureDate"])||(ServiceDate!=assetMap["serviceDate"])){
                              var response=await http.post(Uri.parse("http://10.0.2.2:5000/api/Asset/UpdateAsset"),
                                  headers: {"content-type":"application/json"},
                                  body: json.encode({
                                    "id": assetMap["id"],
                                    "name": assetName.text==assetMap["name"]? null:assetName.text,
                                    "assetNumber": number=="Asset Number"? null:number,
                                    "categoryId": (CategoryId+1)==assetMap["categoryId"]? null:CategoryId+1,
                                    "departmentId": DepartmentId==assetMap["departmentId"]? null:assetMap["departmentId"],
                                    "price": Price.text==assetMap["price"]? null:Price.text,
                                    "manufactureDate": initialDates==assetMap["manufactureDate"]? null:initialDates,
                                    "serviceDate": ServiceDate==assetMap["serviceDate"]? null :ServiceDate,
                                    "registrationTime": null,
                                    "specification": null
                                  })
                              );
                              if(response.statusCode==200){
                                Fluttertoast.showToast(msg: "资产信息更新成功!");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context){
                                      return allAsset();
                                    }));
                              }else{
                                Fluttertoast.showToast(msg: response.body);
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
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child:
                          Column(
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(55),
                                margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child:  Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      color: Color(int.parse("0xffd7d7d7")),
                                      height: ScreenUtil().setHeight(55),
                                      width: ScreenUtil().setWidth(5),
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
                                      width: ScreenUtil().setWidth(116),
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
                                            CategoryId=id-1;
                                          });
                                        },
                                        child:
                                        Icon(Icons.arrow_drop_down,size: 28,color: Color(int.parse("0xff7f7f7f")),),
                                      ),
                                    )

                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  width: ScreenUtil().setWidth(128),
                                  height: ScreenUtil().setHeight(2),
                                  color: Color(int.parse("0xffd6d6d6"),
                                  )
                              ),
                              Container(
                                  height: ScreenUtil().setHeight(35),
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.fromLTRB(17,10, 13, 0),
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
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.fromLTRB(17, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Container(

                                        height: ScreenUtil().setHeight(50),
                                        width: ScreenUtil().setWidth(132),
                                        child: Row(
                                          children: [
                                            Container(

                                              width: ScreenUtil().setWidth(116),
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
                                          margin: EdgeInsets.fromLTRB(0, 0, 7, 0),
                                          width: ScreenUtil().setWidth(128),
                                          height: ScreenUtil().setHeight(2),
                                          color: Color(int.parse("0xffd6d6d6"),
                                          )
                                      ),

                                    ],
                                  )
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(8,0, 3, 0),
                                width: ScreenUtil().setWidth(128),
                                height: ScreenUtil().setHeight(50),
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
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(118),
                                    height: ScreenUtil().setHeight(30),
                                    margin: EdgeInsets.fromLTRB(17, 8, 0, 0),
                                    child: Text(initialDates,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                  ),
                                  InkWell(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: ScreenUtil().setWidth(10),
                                      height: ScreenUtil().setHeight(30),
                                      child: Image.asset("images/icon-calendar.png",fit: BoxFit.fill,),
                                    ),
                                    onTap: ()   {
                                      getTime();
                                    }
                                    ,
                                  )

                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(15, 7,10, 0),
                                  width: ScreenUtil().setWidth(128),
                                  height: ScreenUtil().setHeight(2),
                                  color: Color(int.parse("0xffd6d6d6"),
                                  )
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(17, 8, 0, 0),
                                    width: ScreenUtil().setWidth(118),
                                    height: ScreenUtil().setHeight(30),
                                    child: Text(ServiceDate,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                  ),
                                  InkWell(
                                    child:  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: ScreenUtil().setWidth(10),
                                      height: ScreenUtil().setHeight(30),
                                      child: Image.asset("images/icon-calendar.png",fit: BoxFit.fill,),
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
                                  ),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(15, 7,10, 0),
                                  width: ScreenUtil().setWidth(128),
                                  height: ScreenUtil().setHeight(2),
                                  color: Color(int.parse("0xffd6d6d6"),
                                  )
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.fromLTRB(17, 7, 0, 0),
                                child: Text(number,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(15, 7,10, 0),
                                  width: ScreenUtil().setWidth(128),
                                  height: ScreenUtil().setHeight(2),
                                  color: Color(int.parse("0xffd6d6d6"),
                                  )
                              ),
                            ],
                          ),
                    ),
                    Expanded(
                        flex: 2,
                        child:Column(
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(55),
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child:  Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    color: Color(int.parse("0xffd7d7d7")),
                                    height: ScreenUtil().setHeight(55),
                                    width: ScreenUtil().setWidth(5),
                                  ),
                                  Text("Specification",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                                          width: ScreenUtil().setWidth(128),
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
                                            Icon(Icons.arrow_drop_down,size: 28,color: Color(int.parse("0xff7f7f7f")),),
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
                                      height: ScreenUtil().setHeight(2),
                                      color: Color(int.parse("0xffd6d6d6"),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          width: ScreenUtil().setWidth(128),
                                          child: Text(attributeValue,style: TextStyle(color: Color(int.parse("0xff767676")),fontSize: 13,fontWeight: FontWeight.bold),),
                                        ),
                                        Container(
                                          child: PopupMenuButton(
                                            itemBuilder: (context){
                                              return AttributeValueItems;
                                            },
                                            child:
                                            Icon(Icons.arrow_drop_down,size: 28,color: Color(int.parse("0xff7f7f7f")),),
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
                                      height: ScreenUtil().setHeight(2),
                                      color: Color(int.parse("0xffd6d6d6"),
                                      )
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              child: Container(
                                width: ScreenUtil().setWidth(50),
                                height: ScreenUtil().setHeight(45),
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(160, 10, 0, 0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(int.parse("0xff656565")),width: 1)
                                ),
                                child: Text("Add to list",style: TextStyle(color: Color(int.parse("0xff808080"))),),
                              ),
                              onTap: (){
                                if(attributeName!="Attribute Name") {
                                  if(attributeValue=="Attribute Value"){
                                    Fluttertoast.showToast(msg: "资产规格详情不能为空");
                                  }else {
                                    if (Attributes.length > 0) {
                                      print(Attributes.length);
                                      Attributes.forEach((element) {
                                        if(attributeName==element["name"]){
                                          print("选中的name:${attributeName}");
                                          print("已有的name:${element["name"]}");
                                          Fluttertoast.showToast(
                                            msg: "资产规格名称不能相同！",
                                          );
                                          _OK=false;
                                        }else{
                                          _OK=true;
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
                              height: ScreenUtil().setHeight(200),
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
                                            width: ScreenUtil().setWidth(70),
                                            child: Text(Attributes[index]["name"],style: TextStyle(color: Color(int.parse("0xff3c3d3d")),fontSize: 13),),
                                          ),
                                          Container(
                                            child: Text("/",style: TextStyle(color: Color(int.parse("0xff3c3d3d")),fontSize: 13),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left:10),
                                            width: ScreenUtil().setWidth(30),
                                            child: Text(Attributes[index]["value"],style: TextStyle(color: Color(int.parse("0xff3c3d3d")),fontSize: 13),),
                                          ),
                                          InkWell(
                                            child: Container(
                                              width: ScreenUtil().setWidth(10),
                                              height:ScreenUtil().setHeight(30),
                                              child: Image.asset("images/icon-delete.png",color: Color(int.parse("0xff999999")),fit: BoxFit.fill,),
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
                            ),
                            SizedBox(height: 12,)
                          ],
                        )
                    ),
                    Expanded(
                        flex: 1,
                      child: Column(
                        children: [
                          Container(
                            height: ScreenUtil().setHeight(55),
                            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child:  Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  color: Color(int.parse("0xffd7d7d7")),
                                  height: ScreenUtil().setHeight(55),
                                  width: ScreenUtil().setWidth(5),
                                ),
                                Text("Photo",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(int.parse("0xffcccccc")))
                            ),
                            width: ScreenUtil().setWidth(50),
                            height: ScreenUtil().setHeight(120),
                            child: Image.asset("images/none.png",fit: BoxFit.fill,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(int.parse("0xffcccccc")))
                            ),
                            width: ScreenUtil().setWidth(50),
                            height: ScreenUtil().setHeight(120),
                            child: Image.asset("images/none.png",fit: BoxFit.fill,),
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0,60, 0),
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setHeight(55),
                              child: Image.asset("images/icon-add.png",fit: BoxFit.fill,color: Color(int.parse("0xffaaaaaa")),),
                            ),
                            onTap: () {
                              showPicker();
                            },
                          ),
                          SizedBox(height: 30,)
                        ],
                      ),
                    ),

                  ],
                )
              ],
            ),
            ),
          ),


          ),
    );
  }
}

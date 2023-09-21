import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:warehouse_management_app/screens/addOwnerPage.dart';
import 'package:warehouse_management_app/screens/database/database_helper.dart';
import 'package:warehouse_management_app/screens/model/addProductModel.dart';
import 'package:warehouse_management_app/theme/color.dart';
import 'package:warehouse_management_app/theme/string.dart';
import 'package:warehouse_management_app/theme/theme.dart';
import 'package:warehouse_management_app/uiwidget/robotoTextWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AddProductModel> allProductList = [];
  bool isLoading = false;
  int selectedIndex = 0;
  String oldDateFormat = "dd/MM/yyyy", newDateFormat = "MMM dd yyyy";

  Future<List<Map<String, dynamic>>?> getAllData() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllData();
    setState(() {
      listMap
          .forEach((map) => allProductList.add(AddProductModel.fromMap(map)));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: robotoTextWidget(
            textval: appName,
            colorval: AppColor.whiteColor,
            sizeval: 16,
            fontWeight: FontWeight.w800),
      ),
      body: Stack(children: [
        allProductList.isNotEmpty
            ? Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: allProductList.length,
                    itemBuilder: (context, position) {
                      return listItem(allProductList[position], position);
                    }))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    robotoTextWidget(
                        textval: noDataAvailable,
                        colorval: AppColor.themeColor,
                        sizeval: 14,
                        fontWeight: FontWeight.w400)
                  ],
                ),
              ),
        Center(
          child: isLoading == true
              ? const CircularProgressIndicator(
                  color: AppColor.themeColor,
                )
              : const SizedBox(),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        tooltip: addProduct,
        child: const Icon(Icons.add),
        onPressed: () {
          moveToNextScreen(allProductList, false);
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget listItem(AddProductModel productModel, int position) {
    return  Card(
        color: AppColor.whiteColor,
        elevation: 10,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: AppColor.greyBorder,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
            padding: const EdgeInsets.all(5),
            child: Stack(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(child: Row(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: <Widget>[
                          productModel.photo1.toString().isNotEmpty?
                      Container(
                          width: 30,
                          height: 30,
                          decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:  FileImage(File(productModel.photo1))
                              )
                          )
                      ):SvgPicture.asset(
                            'assets/svg/logo.svg',
                            width: 30,
                            height: 30,
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    robotoTextWidget(
                      textval: productModel.barcode,
                      colorval: AppColor.blackColor,
                      sizeval: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ],),),
                  Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      IconButton(
                          onPressed: () {
                            selectedIndex = position;
                            moveToNextScreen(allProductList, true);
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 25,
                            color: AppColor.themeColor,
                          )),
                      IconButton(
                          onPressed: () {
                            DatabaseHelper.instance.deletedata(
                                allProductList[position].toMapWithoutId());
                            allProductList.removeAt(position);
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 25,
                            color: Colors.red,
                          )),

                    ],),
                  )

                ],
              ),
            ]))
    );
  }

  void moveToNextScreen(List<AddProductModel> allProductList, bool isUpdate) {
    if (allProductList.isNotEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AddOwnerPage(
                    productModel: allProductList[selectedIndex],
                    isUpdate: isUpdate,
                  )),
          (Route<dynamic> route) => true);
    } else {
      AddProductModel addProductModel = AddProductModel(
          ownerGuid: '',
          locationGuid: '',
          requester: '',
          locationName: '',
          countryId: '',
          stateId: '',
          province: '',
          address: '',
          city: '',
          zipCode: '',
          categoryId: '',
          categorySubId: '',
          makeGuid: '',
          modelNumber: '',
          title: '',
          assetDetail: '',
          serialNumber: '',
          selectedDate: '',
          productStatus: '',
          barcode: '',
          purPujNo: '',
          sellType: '',
          classType: '',
          lengthActual: '',
          widthActual: '',
          heightActual: '',
          lengthShipping: '',
          weightLbsActual: '',
          weightLbsShipping: '',
          description: '',
          photo1: '',
          photo2: '',
          photo3: '',
          photo4: '',
          photo5: '');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AddOwnerPage(
                    productModel: addProductModel,
                    isUpdate: false,
                  )),
          (Route<dynamic> route) => true);
    }
  }
}

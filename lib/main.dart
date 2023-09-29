import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:warehouse_management_app/screens/addOwnerPage.dart';
import 'package:warehouse_management_app/screens/database/database_helper.dart';
import 'package:warehouse_management_app/screens/model/addProductModel.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse_management_app/screens/model/productSubmitModel.dart';
import 'package:warehouse_management_app/theme/color.dart';
import 'package:warehouse_management_app/theme/string.dart';
import 'package:warehouse_management_app/theme/theme.dart';
import 'package:warehouse_management_app/uiwidget/robotoTextWidget.dart';
import 'package:warehouse_management_app/utils/utility.dart';
import 'package:warehouse_management_app/webservice/APIDirectory.dart';

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

  String title;
  MyHomePage({super.key, required this.title});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AddProductModel> allProductList = [];
  List<ProductSubmitModel> productList = [];
  List<String>imageArrayList = [];
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
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
    return GestureDetector(
      onTap: (){
        Utility().checkInternetConnection().then((connectionResult) {
          if (connectionResult) {
              setState(() {
                selectedIndex = position;
                isLoading =  true;
              });
           SubmitDataValidation(productModel);
          } else {
            Utility()
                .showInSnackBar(value: checkInternetConnection, context: context);
          }
        });

      },
      child: Card(
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
                                deleteFromDatabase();
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
      ),
    ) ;
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

  void SubmitDataValidation(AddProductModel productModel)  {

    productList = [];
    imageArrayList = [];
      if(productModel.photo1.isNotEmpty){
        imageArrayList.add(json.encode(Utility.getBase64FormateFile(productModel.photo1)));
      }
     if(productModel.photo2.isNotEmpty){
        imageArrayList.add(json.encode(Utility.getBase64FormateFile(productModel.photo2)));
      }
      if(productModel.photo3.isNotEmpty){
        imageArrayList.add(json.encode(Utility.getBase64FormateFile(productModel.photo3)));
      }
      if(productModel.photo4.isNotEmpty){
        imageArrayList.add(json.encode(Utility.getBase64FormateFile(productModel.photo4)));
      }
      if(productModel.photo5.isNotEmpty){
        imageArrayList.add(json.encode(Utility.getBase64FormateFile(productModel.photo5)));
      }

    var resBody = {};
    resBody["OwnerGUID"] = productModel.ownerGuid.toString();
    resBody["LocationGUID"] = productModel.locationGuid.toString();
    resBody["Requestor"] = productModel.requester.toString();
    resBody["PickupRequestNumber"] = productModel.purPujNo.toString();
    resBody["CategoryId"] = productModel.categoryId.toString();
    resBody["CategorySubId"] = productModel.categorySubId.toString();
    resBody["MakeGUID"] = productModel.makeGuid.toString();
    resBody["Model"] = productModel.modelNumber.toString();
    resBody["Title"] = productModel.title.toString();
    resBody["AssetNum"] = productModel.assetDetail.toString();
    resBody["SerialNum"] = productModel.serialNumber.toString();
    resBody["MFGDate"] = productModel.selectedDate.toString();
    resBody["IsWorking"] =  productModel.productStatus.isNotEmpty && productModel.productStatus==working?"1":"0";
    resBody["Barcode"] = productModel.barcode.toString();
    resBody["SellType"] = productModel.sellType.toString();
    resBody["ProductClass"] = productModel.classType.toString();
    resBody["LengthActual"] = productModel.lengthActual.toString();
    resBody["LengthShipping"] = productModel.lengthShipping.toString();
    resBody["HeightActual"] = productModel.heightActual.toString();
    resBody["HeightShipping"] = "0";
    resBody["WidthActual"] = productModel.widthActual.toString();
    resBody["WidthShipping"] = "0";
    resBody["WeightlbsShipping"] = productModel.weightLbsShipping.toString();
    resBody["WeightlbsActual"] = productModel.weightLbsActual.toString();
    resBody["Description"] = productModel.description.toString();
    resBody["images"] = imageArrayList.isNotEmpty?imageArrayList:imageArrayList;

    String value = json.encode(resBody);
    print('value============>${value}');
    SubmitData(value);
  }

  void SubmitData(String value) async {

    String bs64 = base64.encode(value.codeUnits);
    String Checksum =  md5.convert(utf8.encode(bs64)).toString();

    var data ={
      "data": bs64,
      "Checksum": Checksum,

    };

    var finalData = {
      "json": json.encode(data),
      "txtaction": 'AppNewUpload',
    };
    print('finalData============>${finalData}');
    var jsonData = null;
    try {
      var response = await http.post(submitData(),body: finalData);
      var body = jsonDecode(response.body);
      print(body);
      if (body['Result'] == "Success") {
        print('posted successfully!');
        deleteFromDatabase();
        setState(() {
          isLoading = false;
        });
      } else {
        Utility().showToast(body['Message']);

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      e.toString();
      print('error===>${e.toString()}');
      Utility().showToast(e.toString());
      setState(() {
        isLoading = false;
      });
    }
   
    }

  void deleteFromDatabase() {
    DatabaseHelper.instance.deletedata(
        allProductList[selectedIndex].toMapWithoutId());
    allProductList.removeAt(selectedIndex);
    setState(() {});
  }

}


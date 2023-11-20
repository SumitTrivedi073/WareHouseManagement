import 'dart:convert';
import 'dart:io';

import 'package:REUZEIT/utils/constant.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
import '../../webservice/APIDirectory.dart';
import '../database/database_helper.dart';
import 'addOwnerPage.dart';
import 'model/addProductModel.dart';

class MyHomePage extends StatefulWidget {
  String title;

  MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AddProductModel> allProductList = [];
  List<String> productList = [];
  List<String> imageArrayList = [];
  bool isLoading = false;
  int selectedIndex = 0;
  String oldDateFormat = "dd/MM/yyyy",
      newDateFormat = "MMM dd yyyy",
      value = "";
  late SharedPreferences sharedPreferences;

  Future<List<Map<String, dynamic>>?> getAllData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllData();
    setState(() {
      listMap
          .forEach((map) => allProductList.add(AddProductModel.fromMap(map)));
    });
  }

  @override
  void initState() {
    // TODO: implement initStatef
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
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
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

        /* allProductList.isNotEmpty
            ? nextButtonWidget():Container(),*/
      ]),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70.0, right: 10),
          child: FloatingActionButton(
            tooltip: addProduct,
            child: const Icon(Icons.add),
            onPressed: () {
              moveToNextScreen(allProductList, false, 0);
            },
          )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget listItem(AddProductModel productModel, int position) {
    return GestureDetector(
        onTap: () {
          Utility().checkInternetConnection().then((connectionResult) {
            if (connectionResult) {
              setState(() {
                isLoading = true;
                selectedIndex = position;
              });
              SubmitDataValidation(productModel);
              //  updateDatabase(productModel, position, true);
            } else {
              Utility().showInSnackBar(
                  value: checkInternetConnection, context: context);
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
                      Container(
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Stack(
                                children: <Widget>[
                                  productModel.photo1.toString().isNotEmpty
                                      ? Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: FileImage(File(
                                                      productModel.photo1)))))
                                      : SvgPicture.asset(
                                          'assets/svg/logo.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            robotoTextWidget(
                              textval: productModel.barcode,
                              colorval: AppColor.blackColor,
                              sizeval: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  moveToNextScreen(
                                      allProductList, true, position);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 25,
                                  color: AppColor.themeColor,
                                )),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        deleteDialogue(context, position),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 25,
                                  color: Colors.red,
                                )),
                            /*Checkbox(
                          value: productModel.isSelected == 'true'
                              ? true
                              : false,
                          onChanged: (bool? value) {
                            updateDatabase(productModel, position, value);
                          },
                        )*/
                          ],
                        ),
                      )
                    ],
                  ),
                ]))));
  }

  void moveToNextScreen(
      List<AddProductModel> allProductList, bool isUpdate, int position) {
    if (allProductList.isNotEmpty && isUpdate) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AddOwnerPage(
                    productModel: allProductList[position],
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
          heightShipping: '',
          widthShipping: '',
          description: '',
          photo1: '',
          photo2: '',
          photo3: '',
          photo4: '',
          photo5: '',
          isSelected: 'false');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AddOwnerPage(
                    productModel: addProductModel,
                    isUpdate: false,
                  )),
          (Route<dynamic> route) => true);
    }
  }

  void SubmitDataValidation(AddProductModel productModel) {
    productList = [];
    var resBody = {};
    imageArrayList = [];
   /* for (var i = 0; i < allProductList.length; i++) {
      if (allProductList[i].isSelected == 'true') {
   */    if (productModel.photo1.isNotEmpty) {
          imageArrayList.add(
              json.encode(Utility.getBase64FormateFile(productModel.photo1)));
        }
        if (productModel.photo2.isNotEmpty) {
          imageArrayList.add(
              json.encode(Utility.getBase64FormateFile(productModel.photo2)));
        }
        if (productModel.photo3.isNotEmpty) {
          imageArrayList.add(
              json.encode(Utility.getBase64FormateFile(productModel.photo3)));
        }
        if (productModel.photo4.isNotEmpty) {
          imageArrayList.add(
              json.encode(Utility.getBase64FormateFile(productModel.photo4)));
        }
        if (productModel.photo5.isNotEmpty) {
          imageArrayList.add(
              json.encode(Utility.getBase64FormateFile(productModel.photo5)));
        }

        resBody["OwnerGUID"] = productModel.ownerGuid.toString();
        resBody["UserGUID"] = sharedPreferences.getString(userID);
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
        resBody["IsWorking"] = productModel.productStatus.isNotEmpty &&
                productModel.productStatus == working
            ? "1"
            : "0";
        resBody["Barcode"] = productModel.barcode.toString();
        resBody["SellType"] = productModel.sellType.toString();
        resBody["ProductClass"] = productModel.classType.toString();
        resBody["LengthActual"] = productModel.lengthActual.toString();
        resBody["LengthShipping"] = productModel.lengthShipping.toString();
        resBody["HeightActual"] = productModel.heightActual.toString();
        resBody["HeightShipping"] = productModel.heightShipping.toString();
        resBody["WidthActual"] = productModel.widthActual.toString();
        resBody["WidthShipping"] = productModel.widthShipping.toString();
        resBody["WeightlbsShipping"] =
            productModel.weightLbsShipping.toString();
        resBody["WeightlbsActual"] = productModel.weightLbsActual.toString();
        resBody["Description"] = productModel.description.toString();
        resBody["images"] =
        imageArrayList.isNotEmpty ? imageArrayList : imageArrayList;
         value = json.encode(resBody);

        // productList.add(value);



    print('value============>${value.toString()}');
    if (value.toString().isNotEmpty) {
      SubmitData(value);
    } else {
      Utility().showToast('Please Select any item first!');
      setState(() {
        isLoading = false;
      });
    }
  }

  void SubmitData(String value) async {
    String bs64 = base64.encode(value.codeUnits);
    String Checksum = md5.convert(utf8.encode(bs64)).toString();

    var data = {
      "data": bs64,
      "Checksum": Checksum,
    };

    var finalData = {
      "json": json.encode(data),
      "txtaction": 'AppNewUpload',
    };
    print('finalData============>${finalData}');
    print('Checksum============>${Checksum}');
    var jsonData = null;
    try {
      var response = await http.post(submitData(), body: finalData);
      var body = jsonDecode(response.body);
      print(response.body.toString());

      print(body);
      if (body['Result'] == "Success") {
        print('posted successfully!');
        Utility().showToast(body['Message']);
        deleteFromDatabase(selectedIndex);
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

  void deleteFromDatabase(int position) {
    DatabaseHelper.instance
        .deletedata(allProductList[position].toMapWithoutId());
    allProductList.removeAt(position);
    setState(() {});
  }

  void updateDatabase(AddProductModel productModel, int position, bool? value) {
    List<AddProductModel> updateProductList = [];

    AddProductModel addProductModel = AddProductModel(
        ownerGuid: productModel.ownerGuid ?? '',
        locationGuid: productModel.locationGuid ?? '',
        requester: productModel.requester ?? '',
        purPujNo: productModel.purPujNo ?? '',
        locationName: productModel.locationName ?? '',
        countryId: productModel.countryId ?? '',
        stateId: productModel.stateId ?? '',
        province: productModel.province ?? '',
        address: productModel.address ?? '',
        city: productModel.city ?? '',
        zipCode: productModel.zipCode ?? '',
        categoryId: productModel.categoryId ?? '',
        categorySubId: productModel.categorySubId ?? '',
        makeGuid: productModel.makeGuid ?? '',
        modelNumber: productModel.modelNumber ?? '',
        title: productModel.title ?? '',
        assetDetail: productModel.assetDetail ?? '',
        serialNumber: productModel.serialNumber ?? '',
        selectedDate: productModel.selectedDate ?? '',
        productStatus: productModel.productStatus ?? '',
        barcode: productModel.barcode ?? '',
        sellType: productModel.sellType ?? '',
        classType: productModel.classType ?? '',
        lengthActual: productModel.lengthActual ?? '',
        widthActual: productModel.widthActual ?? '',
        heightActual: productModel.heightActual ?? '',
        lengthShipping: productModel.lengthShipping ?? '',
        weightLbsActual: productModel.weightLbsActual ?? '',
        weightLbsShipping: productModel.weightLbsShipping ?? '',
        heightShipping: productModel.heightShipping ?? '',
        widthShipping: productModel.widthShipping ?? '',
        description: productModel.description ?? '',
        photo1: productModel.photo1 ?? '',
        photo2: productModel.photo2 ?? '',
        photo3: productModel.photo3 ?? '',
        photo4: productModel.photo4 ?? '',
        photo5: productModel.photo5 ?? '',
        isSelected: value.toString());
    updateProductList.add(addProductModel);

    setState(() {
      allProductList.setAll(position, updateProductList);
      DatabaseHelper.instance.updateData(addProductModel.toMapWithoutId());
    });
 //   SubmitDataValidation();
  }

  deleteDialogue(BuildContext context, int position) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              wantToDelete,
              style: const TextStyle(
                  color: AppColor.themeColor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: cancel,
                      colorval: AppColor.blackColor,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      deleteFromDatabase(position);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: confirm,
                      colorval: AppColor.whiteColor,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ]),
        ));
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        showDialog(
            context: context,
            builder: (BuildContext context) => logoutDialogue(context));

        break;
    }
  }

  logoutDialogue(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  wantToLogout,
                  style: const TextStyle(
                      color: AppColor.themeColor,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: robotoTextWidget(
                          textval: cancel,
                          colorval: AppColor.blackColor,
                          sizeval: 14,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Utility().clearSharedPreference();
                      DatabaseHelper.instance.deleteTable();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: robotoTextWidget(
                          textval: confirm,
                          colorval: AppColor.whiteColor,
                          sizeval: 14,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}

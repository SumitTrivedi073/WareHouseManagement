import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_management_app/screens/addLocationWidget.dart';
import 'package:warehouse_management_app/screens/addProductDetailPage.dart';
import 'package:warehouse_management_app/screens/model/ownerListModel.dart'
    as ownerPrefix;
import 'package:warehouse_management_app/screens/model/sourceLocModel.dart'
    as sourceLocPrefix;
import 'package:warehouse_management_app/utils/constant.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../utils/utility.dart';
import 'model/addProductModel.dart';

class AddOwnerPage extends StatefulWidget {
  AddOwnerPage({Key? key, required this.productModel, required this.isUpdate})
      : super(key: key);

  AddProductModel productModel;
  bool isUpdate;

  @override
  State<AddOwnerPage> createState() => _AddOwnerPageState();
}

class _AddOwnerPageState extends State<AddOwnerPage> {
  String? SelectOwnerType,
      SelectSourceLocType,
      SelectCountryType,
      SelectStateType;
  List<ownerPrefix.Datum> selectOwnerList = [];

  List<sourceLocPrefix.Datum> selectSourceLocList = [];
  List<AddProductModel> productList = [];
  TextEditingController sourceLocController = TextEditingController();
  TextEditingController requesterController = TextEditingController();
  TextEditingController purPrjController = TextEditingController();
  bool ischecked = false;
  late SharedPreferences sharedPreferences;
  AddProductModel? addProductModel1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
    if (widget.isUpdate) {
      setData();
    } else {
      getSharedPrefrence();
    }
  }

  void setData() {
    if (widget.productModel.ownerGuid.isNotEmpty) {
      SelectOwnerType = widget.productModel.ownerGuid;
    }
    requesterController.text = widget.productModel.requester ?? '';
    purPrjController.text = widget.productModel.purPujNo ?? '';
    getSourceLocList(widget.isUpdate);
    addProductModel1 = widget.productModel;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: robotoTextWidget(
              textval: addOwnerPage,
              colorval: AppColor.whiteColor,
              sizeval: 16,
              fontWeight: FontWeight.w800),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(children: [
          Container(
              margin: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ownerSpinnerWidget(),
                    sourceLocSpinnerWidget(),
                    addRemoveLocManually(),
                    textWidget(requesterController, TextInputType.text,
                        enterRequester),
                    textWidget(
                        purPrjController, TextInputType.text, enterPurPuj),
                  ],
                ),
              )),
          nextButtonWidget()
        ]));
  }

  Widget addRemoveLocManually() {
    return GestureDetector(
        onTap: () {
          SelectOwnerType ??= "";

          if (SelectOwnerType.toString().isNotEmpty) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => AddLocationWidgetPage(
                          callback: retriveLocationData,
                          addProductModel: widget.productModel,
                          isUpdate: widget.isUpdate,
                        )),
                (Route<dynamic> route) => true);
          } else {
            SelectOwnerType = null;
            Utility().showToast(selectOwner2);
          }
        },
        child: Container(
          margin: EdgeInsets.only(top: 10, right: 10),
          child: Align(
            alignment: Alignment.centerRight,
            child: robotoTextWidget(
                textval: addLocManually,
                colorval: AppColor.themeColor,
                sizeval: 14,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  ownerSpinnerWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.themeColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintStyle: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600),
              hintText: selectOwner,
              fillColor: Colors.white),
          value: SelectOwnerType,
          validator: (value) =>
              value == null || value.isEmpty ? selectClassType : "",
          items: selectOwnerList
              .map((ownerlist) => DropdownMenuItem(
                  value: ownerlist.ownerGuid,
                  child: robotoTextWidget(
                      textval: ownerlist.ownerName,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              SelectOwnerType = value.toString();
              SelectSourceLocType = null;
              getSourceLocList(false);
            });
          },
        ));
  }

  sourceLocSpinnerWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.themeColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintStyle: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600),
              hintText: selectSourceLocation,
              fillColor: Colors.white),
          value: SelectSourceLocType,
          validator: (value) =>
              value == null || value.isEmpty ? selectClassType : "",
          items: selectSourceLocList
              .map((ownerlist) => DropdownMenuItem(
                  value: ownerlist.locationGuid,
                  child: robotoTextWidget(
                      textval: ownerlist.longName!,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              SelectSourceLocType = value.toString();
            });
          },
        ));
  }

  textWidget(TextEditingController controller, TextInputType inputType,
      String hintTxt) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextField(
            controller: controller,
            style: const TextStyle(
                color: AppColor.themeColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto'),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: const TextStyle(
                  color: AppColor.darkGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto'),
            ),
            keyboardType: inputType,
            textInputAction:
                hintTxt == enterPurPuj || hintTxt == enterZipcode
                    ? TextInputAction.done
                    : TextInputAction.next),
      ),
    );
  }

  nextButtonWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CheckboxListTile(
              title: robotoTextWidget(
                  textval: saveOwnerSourceLoc,
                  colorval: AppColor.themeColor,
                  sizeval: 14,
                  fontWeight: FontWeight.normal),
              controlAffinity: ListTileControlAffinity.leading,
              checkColor: AppColor.whiteColor,
              activeColor: AppColor.themeColor,
              value: ischecked,
              onChanged: (value) {
                setState(() {
                  ischecked = value!;
                });
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 150,
                  height: 50,
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.themeColor),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: AppColor.whiteColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      robotoTextWidget(
                          textval: back,
                          colorval: Colors.white,
                          sizeval: 16,
                          fontWeight: FontWeight.bold),
                    ],
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  moveToNextScreen();
                },
                child: Container(
                  width: 150,
                  height: 50,
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.themeColor),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      robotoTextWidget(
                          textval: next,
                          colorval: Colors.white,
                          sizeval: 16,
                          fontWeight: FontWeight.bold),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColor.whiteColor,
                        size: 20,
                      )
                    ],
                  )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> getList() async {
    String data = await rootBundle.loadString('assets/api_json/ownerlist.json');
    var jsonData = convert.jsonDecode(data);
    ownerPrefix.OwnerListModel ownerListModel =
        ownerPrefix.OwnerListModel.fromJson(jsonData);
    setState(() {
      selectOwnerList = ownerListModel.data;
    });
  }

  Future<void> getSourceLocList(bool isUpdate) async {
    String data1 =
        await rootBundle.loadString('assets/api_json/sourceLocList.json');
    var jsonData1 = convert.jsonDecode(data1);
    sourceLocPrefix.SourceLocModel sourceLocModel =
        sourceLocPrefix.SourceLocModel.fromJson(jsonData1);
    List<sourceLocPrefix.Datum> initialList = [];
    initialList = sourceLocModel.data;
    for (sourceLocPrefix.Datum sourceLoc in initialList) {
      if (sourceLoc.ownerGuid == SelectOwnerType) {
        if (sourceLoc.longName!.isNotEmpty) {
          selectSourceLocList.add(sourceLoc);
        }
      }
    }
    if (isUpdate) {
      if (widget.productModel.locationGuid.isNotEmpty) {
        SelectSourceLocType = widget.productModel.locationGuid ?? '';
      }
    } else {
      sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.getString(selectSourceLocType) != null &&
          sharedPreferences
              .getString(selectSourceLocType)
              .toString()
              .isNotEmpty) {
        SelectSourceLocType =
            sharedPreferences.getString(selectSourceLocType).toString();
      } else {
        SelectSourceLocType = "eef75434-722a-a5e0-9596-a46a16ec6bff";
      }
    }

    setState(() {});
  }

  Future<void> moveToNextScreen() async {
    SelectOwnerType ??= "";
    SelectSourceLocType ??= "";
    if (SelectOwnerType!.isEmpty) {
      // SelectOwnerType = null;
      // Utility().showToast(selectOwner);
    }
    if (SelectSourceLocType!.isEmpty) {
      //  SelectSourceLocType = null;
      // Utility().showToast(selectSourceLocation);
    } else if (requesterController.text.toString().isEmpty) {
      //  Utility().showToast(enterRequester);
    } else {
      if (ischecked) {
        Utility().setSharedPreference(selectOwnerType, SelectOwnerType!);
        Utility()
            .setSharedPreference(selectSourceLocType, SelectSourceLocType!);
        Utility().setSharedPreference(
            selectRequester, requesterController.text.toString());
      } else {
        sharedPreferences = await SharedPreferences.getInstance();
        if (sharedPreferences.getString(selectOwnerType) != null &&
            sharedPreferences
                .getString(selectOwnerType)
                .toString()
                .isNotEmpty) {
          Utility().clearSharedPreference();
        }
      }
    }

    AddProductModel addProductModel = AddProductModel(
        ownerGuid: SelectOwnerType ?? '',
        locationGuid: SelectSourceLocType ?? '',
        requester: requesterController.text.toString() ?? '',
        purPujNo: purPrjController.text.toString() ?? '',
        locationName: addProductModel1 != null && addProductModel1!.locationName.toString().isNotEmpty ? addProductModel1!.locationName.toString() : '',
        countryId: addProductModel1 != null && addProductModel1!.countryId.toString().isNotEmpty ? addProductModel1!.countryId.toString() : '',
        stateId: addProductModel1 != null && addProductModel1!.stateId.toString().isNotEmpty ? addProductModel1!.stateId.toString() : '',
        province: addProductModel1 != null && addProductModel1!.province.toString().isNotEmpty ? addProductModel1!.province.toString() : '',
        address: addProductModel1 != null && addProductModel1!.address.toString().isNotEmpty ? addProductModel1!.address.toString() : '',
        city: addProductModel1 != null && addProductModel1!.city.toString().isNotEmpty ? addProductModel1!.city.toString() : '',
        zipCode: addProductModel1 != null && addProductModel1!.zipCode.toString().isNotEmpty ? addProductModel1!.zipCode.toString() : '',
        categoryId: addProductModel1 != null && addProductModel1!.categoryId.toString().isNotEmpty ? addProductModel1!.categoryId.toString() : '',
        categorySubId: addProductModel1 != null && addProductModel1!.categorySubId.toString().isNotEmpty ? addProductModel1!.categorySubId.toString() : '',
        makeGuid: addProductModel1 != null && addProductModel1!.makeGuid.toString().isNotEmpty ? addProductModel1!.makeGuid.toString() : '',
        modelNumber: addProductModel1 != null && addProductModel1!.modelNumber.toString().isNotEmpty ? addProductModel1!.modelNumber.toString() : '',
        title: addProductModel1 != null && addProductModel1!.title.toString().isNotEmpty ? addProductModel1!.title.toString() : '',
        assetDetail: addProductModel1 != null && addProductModel1!.assetDetail.toString().isNotEmpty ? addProductModel1!.assetDetail.toString() : '',
        serialNumber: addProductModel1 != null && addProductModel1!.serialNumber.toString().isNotEmpty ? addProductModel1!.serialNumber.toString() : '',
        selectedDate: addProductModel1 != null && addProductModel1!.selectedDate.toString().isNotEmpty ? addProductModel1!.selectedDate.toString() : '',
        productStatus: addProductModel1 != null && addProductModel1!.productStatus.toString().isNotEmpty ? addProductModel1!.productStatus.toString() : '',
        barcode: addProductModel1 != null && addProductModel1!.barcode.toString().isNotEmpty ? addProductModel1!.barcode.toString() : '',
        sellType: addProductModel1 != null && addProductModel1!.sellType.toString().isNotEmpty ? addProductModel1!.sellType.toString() : '',
        classType: addProductModel1 != null && addProductModel1!.classType.toString().isNotEmpty ? addProductModel1!.classType.toString() : '',
        lengthActual: addProductModel1 != null && addProductModel1!.lengthActual.toString().isNotEmpty ? addProductModel1!.lengthActual.toString() : '',
        widthActual: addProductModel1 != null && addProductModel1!.widthActual.toString().isNotEmpty ? addProductModel1!.widthActual.toString() : '',
        heightActual: addProductModel1 != null && addProductModel1!.heightActual.toString().isNotEmpty ? addProductModel1!.heightActual.toString() : '',
        lengthShipping: addProductModel1 != null && addProductModel1!.lengthShipping.toString().isNotEmpty ? addProductModel1!.lengthShipping.toString() : '',
        weightLbsActual: addProductModel1 != null && addProductModel1!.weightLbsActual.toString().isNotEmpty ? addProductModel1!.weightLbsActual.toString() : '',
        weightLbsShipping: addProductModel1 != null && addProductModel1!.weightLbsShipping.toString().isNotEmpty ? addProductModel1!.weightLbsShipping.toString() : '',
        description: addProductModel1 != null && addProductModel1!.description.toString().isNotEmpty ? addProductModel1!.description.toString() : '',
        photo1: addProductModel1 != null && addProductModel1!.photo1.toString().isNotEmpty ? addProductModel1!.photo1.toString() : '',
        photo2: addProductModel1 != null && addProductModel1!.photo2.toString().isNotEmpty ? addProductModel1!.photo2.toString() : '',
        photo3: addProductModel1 != null && addProductModel1!.photo3.toString().isNotEmpty ? addProductModel1!.photo3.toString() : '',
        photo4: addProductModel1 != null && addProductModel1!.photo4.toString().isNotEmpty ? addProductModel1!.photo4.toString() : '',
        photo5: addProductModel1 != null && addProductModel1!.photo5.toString().isNotEmpty ? addProductModel1!.photo5.toString() : '',
        isSelected: addProductModel1 != null && addProductModel1!.isSelected.toString().isNotEmpty ? addProductModel1!.isSelected.toString() : 'false');
    print('addProductModel===========>$addProductModel');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => AddProductDetailPage(
                  addProductModel: addProductModel,
                  isUpdate: widget.isUpdate,
                )),
        (Route<dynamic> route) => true);
  }

  Future<void> getSharedPrefrence() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(selectOwnerType) != null &&
        sharedPreferences.getString(selectOwnerType).toString().isNotEmpty) {
      SelectOwnerType = sharedPreferences.getString(selectOwnerType).toString();
      requesterController.text =
          sharedPreferences.getString(selectRequester).toString();
      ischecked = true;
      getSourceLocList(widget.isUpdate);
      setState(() {});
    } else {
      getSourceLocList(widget.isUpdate);
      SelectOwnerType = "5fcb6c50-d8bd-3f07-dbab-d1473523b6af";
    }
  }

  void retriveLocationData(AddProductModel addProductModel) {
    setState(() {
      addProductModel1 = addProductModel;
    });
    print('addProductModel1!===========>$addProductModel1!');
  }
}

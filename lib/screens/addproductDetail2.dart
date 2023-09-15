import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warehouse_management_app/screens/adddimentions.dart';
import 'package:warehouse_management_app/screens/model/addProductModel.dart';

import 'package:warehouse_management_app/screens/model/productClassModel.dart'as classPrefix;
import 'package:warehouse_management_app/screens/model/sellTypeModel.dart'as sellTypePrefix;
import 'dart:convert' as convert;
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../utils/utility.dart';

class AddProductDetailPage2 extends StatefulWidget {
  const AddProductDetailPage2({Key? key}) : super(key: key);

  @override
  State<AddProductDetailPage2> createState() => _AddProductDetailPage2State();
}

class _AddProductDetailPage2State extends State<AddProductDetailPage2> {
  String? selectedClassType,selectedSellType;
  List<classPrefix.Datum> ClassList = [];
  List<sellTypePrefix.Datum> sellTypeList = [];
  List<AddProductModel> productList =[];
  TextEditingController barCodeController = TextEditingController();
  TextEditingController purPrjController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: robotoTextWidget(
              textval: addProductDetail,
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
              width: double.infinity,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [

                textWidget(barCodeController, TextInputType.text, enterBarcode),
               textWidget(purPrjController, TextInputType.text, enterPurPuj),
                    sellTypeSpinnerWidget(),
                    classSpinnerWidget(),
                    ]))),
              nextButtonWidget(),
        ]));
  }

  sellTypeSpinnerWidget() {
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
              hintText: selectSellType,
              fillColor: Colors.white),
          value: selectedSellType,
          validator: (value) =>
              value == null || value.isEmpty ? selectClassType : "",
          items: sellTypeList
              .map((sellType) => DropdownMenuItem(
                  value: sellType.id,
                  child: robotoTextWidget(
                      textval: sellType.description,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              selectedSellType = value.toString();
            });
          },
        ));
  }
  classSpinnerWidget() {
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
              hintText: selectClassType,
              fillColor: Colors.white),
          value: selectedClassType,
          validator: (value) =>
          value == null || value.isEmpty ? selectClassType : "",
          items: ClassList
              .map((classList) => DropdownMenuItem(
              value: classList.id,
              child: robotoTextWidget(
                  textval: classList.title,
                  colorval: AppColor.themeColor,
                  sizeval: 14,
                  fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              selectedClassType = value.toString();
            });
          },
        ));
  }

  textWidget(TextEditingController Controller, TextInputType inputType,
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
            controller: Controller,
            style: const TextStyle(color: AppColor.themeColor, fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto'),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle:const TextStyle(
                  color: AppColor.darkGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto'),
            ),
            keyboardType: inputType,
            textInputAction: hintTxt == enterPurPuj
                ? TextInputAction.done
                : TextInputAction.next),
      ),
    );
  }

  nextButtonWidget() {
    return  Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          moveToNextScreen();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
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
                  const SizedBox(width: 5,),
                  const Icon(Icons.arrow_forward,color: AppColor.whiteColor,
                    size: 20,)
                ],
              )),
        ),
      ),
    );
  }

  Future<void> getList() async {
    String data = await rootBundle.loadString('assets/api_json/productclass.json');
    var jsonData = convert.jsonDecode(data);
    classPrefix.ProductClassModel productClassModel =
    classPrefix.ProductClassModel.fromJson(jsonData);

    String data1 = await rootBundle.loadString('assets/api_json/selltype.json');
    var jsonData1 = convert.jsonDecode(data1);
    sellTypePrefix.SellTypeModel sellTypeModel =
    sellTypePrefix.SellTypeModel.fromJson(jsonData1);

    setState(() {
      ClassList = productClassModel.data;
      sellTypeList = sellTypeModel.data;
    });

  }

  void moveToNextScreen() {
    selectedClassType ??= "";
    selectedSellType ??= "";
     if (barCodeController.text.toString().isEmpty) {
      Utility().showToast(enterBarcode);
    }else if (purPrjController.text.toString().isEmpty) {
      Utility().showToast(enterPurPuj);
    }else if (selectedSellType!.isEmpty) {
       selectedSellType = null;
       Utility().showToast(selectSellType);
     }else if (selectedClassType!.isEmpty) {
       selectedClassType = null;
       Utility().showToast(selectClassType);
     }else{
       Navigator.of(context).pushAndRemoveUntil(
           MaterialPageRoute(
               builder: (BuildContext context) =>  AddDimensionsPage()),
               (Route<dynamic> route) => true);
     }
  }


}

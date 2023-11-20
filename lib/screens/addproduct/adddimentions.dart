import 'package:flutter/material.dart';
import 'package:REUZEIT/screens/addproduct/model/addProductModel.dart';

import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../addproduct/adddiscriptionPage.dart';

class AddDimensionsPage extends StatefulWidget {
  AddDimensionsPage(
      {Key? key, required this.addProductModel, required this.isUpdate})
      : super(key: key);
  AddProductModel addProductModel;
  bool isUpdate;

  @override
  State<AddDimensionsPage> createState() => _AddDimensionsPageState();
}

class _AddDimensionsPageState extends State<AddDimensionsPage> {
  TextEditingController lengthActCodeController = TextEditingController();
  TextEditingController widthActController = TextEditingController();
  TextEditingController heightActController = TextEditingController();
  TextEditingController weightLbsActController = TextEditingController();
  
  List<AddProductModel> productList1 = [];
  String selectStatus = actualDimensions,
      heightShipping = "",
      widthShipping = "",lengthShipping="",weightLbsShipping="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdate) {
      lengthActCodeController.text = widget.addProductModel.lengthActual ?? '';
      widthActController.text = widget.addProductModel.widthActual ?? '';
      heightActController.text = widget.addProductModel.heightActual ?? '';
      lengthShipping =
          widget.addProductModel.lengthShipping ?? '';
      weightLbsActController.text =
          widget.addProductModel.weightLbsActual ?? '';
      weightLbsShipping =
          widget.addProductModel.weightLbsShipping ?? '';
      heightShipping = widget.addProductModel.heightShipping ??'';
      widthShipping = widget.addProductModel.widthShipping ??'';
    } else {
      lengthShipping = "0";
      weightLbsShipping = "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: robotoTextWidget(
              textval: addDimensions,
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
                    radioWidget(),
                    editTextWidget(lengthActCodeController,
                        TextInputType.number, enterLengthAct),
                    editTextWidget(widthActController, TextInputType.number,
                        enterWidthAct),
                    editTextWidget(heightActController, TextInputType.number,
                        enterHeightAct),
                    editTextWidget(weightLbsActController, TextInputType.number,
                        enterWeightLbsAct),
                   
                  ]))),
          nextButtonWidget(),
        ]));
  }

  radioWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: ListTile(
          leading: Radio<String>(
            activeColor: AppColor.themeColor,
            value: actualDimensions,
            groupValue: selectStatus,
            onChanged: (value) {
              setState(() {
                selectStatus = value!;
                calculateDimentions("0");
              });
            },
          ),
          title: robotoTextWidget(
              textval: actualDimensions,
              colorval: AppColor.themeColor,
              sizeval: 14,
              fontWeight: FontWeight.bold),
        )),
        Expanded(
            child: ListTile(
          leading: Radio<String>(
            activeColor: AppColor.themeColor,
            value: shippingDimensions,
            groupValue: selectStatus,
            onChanged: (value) {
              setState(() {
                selectStatus = value!;
                calculateDimentions("0");
              });
            },
          ),
          title: robotoTextWidget(
              textval: shippingDimensions,
              colorval: AppColor.themeColor,
              sizeval: 14,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  editTextWidget(TextEditingController controller, TextInputType inputType,
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
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto'),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: const TextStyle(
                  color: AppColor.darkGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto'),
            ),
            onChanged: (value) {
              if (value.toString().isNotEmpty &&
                  value.toString() != "0" &&
                  value.toString() != "0.0") {
                if (selectStatus == actualDimensions) {
                  if (hintTxt == enterLengthAct) {
                    lengthShipping =
                        (int.parse(value.toString()) * 1.25).toString();
                  }
                  if (hintTxt == enterWeightLbsAct) {
                    weightLbsShipping =
                        (int.parse(value.toString()) * 1.25).toString();
                  }

                  if (hintTxt == enterWidthAct) {
                    widthShipping =
                        (int.parse(value.toString()) * 1.25).toString();
                  }
                  if (hintTxt == enterHeightAct) {
                    heightShipping =
                        (int.parse(value.toString()) * 1.25).toString();
                  }
                }else{
                  if (hintTxt == enterLengthAct) {
                    lengthShipping =
                        (int.parse(value.toString()) * 0.75).toString();
                  }
                  if (hintTxt == enterWeightLbsAct) {
                    weightLbsShipping =
                        (int.parse(value.toString()) * 0.75).toString();
                  }

                  if (hintTxt == enterWidthAct) {
                    widthShipping =
                        (int.parse(value.toString()) * 0.75).toString();
                  }
                  if (hintTxt == enterHeightAct) {
                    heightShipping =
                        (int.parse(value.toString()) * 0.75).toString();
                  }
                }

                setState(() {});
              }else{
                lengthShipping = "0";
                weightLbsShipping = "0";
                setState(() {});
              }
            },
            onTapOutside: (event) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }},
            keyboardType: inputType,
            textInputAction: hintTxt == enterWeightLbsAct
                ? TextInputAction.done
                : TextInputAction.next),

      ),
    );
  }

  textWidget(TextEditingController Controller) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 15,bottom: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.themeColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: robotoTextWidget(
                textval: Controller.text,
                colorval: AppColor.themeColor,
                sizeval: 12,
                fontWeight: FontWeight.w600)));
  }

  nextButtonWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 150,
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
              calculateDimentions("1");
            },
            child: Container(
              width: 150,
              height: 50,
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
      ),
    );
  }

  void moveToNextScreen() {
    /* if (lengthActCodeController.text.toString().isEmpty) {
      Utility().showToast(enterLengthAct);
    } else if (widthActController.text.toString().isEmpty) {
      Utility().showToast(enterWidthAct);
    } else if (heightActController.text.toString().isEmpty) {
      Utility().showToast(enterHeightAct);
    } else if (lengthShipping.toString().isEmpty) {
      Utility().showToast(enterLengthShipping);
    }else if (weightLbsActController.text.toString().isEmpty) {
    Utility().showToast(enterWeightLbsAct);
  }else if (weightLbsShipping.toString().isEmpty) {
    Utility().showToast(enterWeightLbsShipping);
  } else {
*/

    AddProductModel addProductModel = AddProductModel(
        ownerGuid: widget.addProductModel.ownerGuid ??  '',
        locationGuid: widget.addProductModel.locationGuid ?? '',
        requester: widget.addProductModel.requester ?? '',
        purPujNo: widget.addProductModel.purPujNo ?? '',
        locationName: widget.addProductModel.locationName ?? '',
        countryId: widget.addProductModel.countryId ?? '',
        stateId: widget.addProductModel.stateId ?? '',
        province: widget.addProductModel.province ?? '',
        address: widget.addProductModel.address ?? '',
        city: widget.addProductModel.city ?? '',
        zipCode: widget.addProductModel.zipCode ?? '',
        categoryId: widget.addProductModel.categoryId ?? '',
        categorySubId: widget.addProductModel.categorySubId ?? '',
        makeGuid: widget.addProductModel.makeGuid ?? '',
        modelNumber: widget.addProductModel.modelNumber ?? '',
        title: widget.addProductModel.title ?? '',
        assetDetail: widget.addProductModel.assetDetail ?? '',
        serialNumber: widget.addProductModel.serialNumber ?? '',
        selectedDate: widget.addProductModel.selectedDate ?? '',
        productStatus: widget.addProductModel.productStatus ?? '',
        barcode: widget.addProductModel.barcode ?? '',
        sellType: widget.addProductModel.sellType ?? '',
        classType: widget.addProductModel.classType ?? '',
        lengthActual: lengthActCodeController.text.toString() ?? '',
        widthActual: widthActController.text.toString() ?? '',
        heightActual: heightActController.text.toString() ?? '',
        lengthShipping: lengthShipping.toString() ?? '',
        weightLbsActual: weightLbsActController.text.toString() ?? '',
        weightLbsShipping: weightLbsShipping.toString() ?? '',
        heightShipping: heightShipping??'',
        widthShipping: widthShipping??'',
        description: widget.addProductModel.description.toString().isNotEmpty
            ? widget.addProductModel.description.toString()
            : '',
        photo1: widget.addProductModel.photo1.toString().isNotEmpty
            ? widget.addProductModel.photo1.toString()
            : '',
        photo2: widget.addProductModel.photo2.toString().isNotEmpty
            ? widget.addProductModel.photo2.toString()
            : '',
        photo3: widget.addProductModel.photo3.toString().isNotEmpty
            ? widget.addProductModel.photo3.toString()
            : '',
        photo4: widget.addProductModel.photo4.toString().isNotEmpty
            ? widget.addProductModel.photo4.toString()
            : '',
        photo5: widget.addProductModel.photo5.toString().isNotEmpty
            ? widget.addProductModel.photo5.toString()
            : '',
        isSelected: widget.addProductModel.isSelected.toString().isNotEmpty
            ? widget.addProductModel.isSelected.toString()
            : 'false');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => AddDescriptionPage(
                addProductModel: addProductModel, isUpdate: widget.isUpdate)),
        (Route<dynamic> route) => true);
  }

  void calculateDimentions(String value) {
    if (selectStatus == actualDimensions) {
      if (lengthActCodeController.text.isNotEmpty &&
          lengthActCodeController.text != "0" &&
          lengthActCodeController.text != "0.0") {
        lengthShipping =
            (int.parse(lengthActCodeController.text) * 1.25).toString();
      }
      if (weightLbsActController.text.isNotEmpty &&
          weightLbsActController.text != "0" &&
          weightLbsActController.text != "0.0") {
        weightLbsShipping =
            (int.parse(weightLbsActController.text) * 1.25).toString();
      }

      if (heightActController.text.isNotEmpty &&
          heightActController.text != "0" &&
          heightActController.text != "0.0") {
        heightShipping =
            (int.parse(heightActController.text) * 1.25).toString();
      }

      if (widthActController.text.isNotEmpty &&
          widthActController.text != "0" &&
          widthActController.text != "0.0") {
        widthShipping = (int.parse(widthActController.text) * 1.25).toString();
      }
    } else {
      if (lengthActCodeController.text.isNotEmpty &&
          lengthActCodeController.text != "0" &&
          lengthActCodeController.text != "0.0") {
        lengthShipping =
            (int.parse(lengthActCodeController.text) * 0.75).toString();
      }
      if (weightLbsActController.text.isNotEmpty &&
          weightLbsActController.text != "0" &&
          weightLbsActController.text != "0.0") {
        weightLbsShipping =
            (int.parse(weightLbsActController.text) * 0.75).toString();
      }

      if (heightActController.text.isNotEmpty &&
          heightActController.text != "0" &&
          heightActController.text != "0.0") {
        heightShipping =
            (int.parse(heightActController.text) * 0.75).toString();
      }

      if (widthActController.text.isNotEmpty &&
          widthActController.text != "0" &&
          widthActController.text != "0.0") {
        widthShipping = (int.parse(widthActController.text) * 0.75).toString();
      }
    }
    setState(() {
      if (value == "1") {
        moveToNextScreen();
      }
    });
  }

//}
}

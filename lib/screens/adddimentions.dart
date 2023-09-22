import 'package:flutter/material.dart';
import 'package:warehouse_management_app/screens/model/addProductModel.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import 'adddiscriptionPage.dart';

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
  TextEditingController lengthShippingController = TextEditingController();
  TextEditingController weightLbsActController = TextEditingController();
  TextEditingController weightLbsShippingController = TextEditingController();
  List<AddProductModel> productList1 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdate) {
      lengthActCodeController.text = widget.addProductModel.lengthActual ?? '';
      widthActController.text = widget.addProductModel.widthActual ?? '';
      heightActController.text = widget.addProductModel.heightActual ?? '';
      lengthShippingController.text =
          widget.addProductModel.lengthShipping ?? '';
      weightLbsActController.text =
          widget.addProductModel.weightLbsActual ?? '';
      weightLbsShippingController.text =
          widget.addProductModel.weightLbsShipping ?? '';
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
                    textWidget(lengthActCodeController, TextInputType.number,
                        enterLengthAct),
                    textWidget(widthActController, TextInputType.number,
                        enterWidthAct),
                    textWidget(heightActController, TextInputType.number,
                        enterHeightAct),
                    textWidget(lengthShippingController, TextInputType.number,
                        enterLengthShipping),
                    textWidget(weightLbsActController, TextInputType.number,
                        enterWeightLbsAct),
                    textWidget(weightLbsShippingController,
                        TextInputType.number, enterWeightLbsShipping),
                  ]))),
          nextButtonWidget(),
        ]));
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
            keyboardType: inputType,
            textInputAction: hintTxt == enterWeightLbsShipping
                ? TextInputAction.done
                : TextInputAction.next),
      ),
    );
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
              moveToNextScreen();
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
    } else if (lengthShippingController.text.toString().isEmpty) {
      Utility().showToast(enterLengthShipping);
    }else if (weightLbsActController.text.toString().isEmpty) {
    Utility().showToast(enterWeightLbsAct);
  }else if (weightLbsShippingController.text.toString().isEmpty) {
    Utility().showToast(enterWeightLbsShipping);
  } else {
*/
    AddProductModel addProductModel = AddProductModel(
        ownerGuid: widget.addProductModel.ownerGuid ?? '',
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
        lengthShipping: lengthShippingController.text.toString() ?? '',
        weightLbsActual: weightLbsActController.text.toString() ?? '',
        weightLbsShipping: weightLbsShippingController.text.toString() ?? '',
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
            : '');

    print(
        'addProductMode444444==================>${addProductModel.toString()}');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => AddDescriptionPage(
                addProductModel: addProductModel, isUpdate: widget.isUpdate)),
        (Route<dynamic> route) => true);
  }
//}
}

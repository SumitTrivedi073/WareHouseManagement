import 'package:flutter/material.dart';
import 'package:warehouse_management_app/screens/model/addProductModel.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../utils/utility.dart';
import 'addProductDetailPage.dart';
import 'adddiscriptionPage.dart';

class AddDimensionsPage extends StatefulWidget {
   AddDimensionsPage({Key? key}) : super(key: key);

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset : false,
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
                textWidget(
                    lengthActCodeController, TextInputType.number, enterLengthAct),
                textWidget(widthActController, TextInputType.number, enterWidthAct),
                textWidget(
                    heightActController, TextInputType.number, enterHeightAct),
                textWidget(
                    lengthShippingController, TextInputType.number, enterLengthShipping),
                textWidget(weightLbsActController, TextInputType.number,
                    enterWeightLbsAct),
                textWidget(weightLbsShippingController, TextInputType.number,
                    enterWeightLbsShipping),
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
            style: const TextStyle(color: AppColor.themeColor, fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto'),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: const TextStyle(color: AppColor.darkGrey, fontSize: 12,
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
      child: GestureDetector(
        onTap: () {
          moveToNextScreen();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
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
    );
  }



  void moveToNextScreen() {
  if (lengthActCodeController.text.toString().isEmpty) {
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
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) =>  AddDescriptionPage()),
            (Route<dynamic> route) => true);
    }
  }
}

import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../utils/utility.dart';
import 'model/addProductModel.dart';

class AddDescriptionPage extends StatefulWidget {
  AddDescriptionPage({Key? key}) : super(key: key);

  @override
  State<AddDescriptionPage> createState() => _AddDescriptionPageState();
}

class _AddDescriptionPageState extends State<AddDescriptionPage> {

  TextEditingController descriptionController = TextEditingController();
  TextEditingController descriptionHtmlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: robotoTextWidget(
              textval: addDescription,
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
              height: double.infinity,
              width: double.infinity,
              child:  SingleChildScrollView(child: Column(children: [

                textWidget(descriptionController, TextInputType.text, enterDescription),
                ])
              )
          ),
          nextButtonWidget(),
        ]));
  }

  textWidget(TextEditingController controller, TextInputType inputType,
      String hintTxt) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.themeColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TextField(
            controller: controller,
            style: const TextStyle(color: AppColor.themeColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto'),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: const TextStyle(color: AppColor.themeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto'),
            ),
            keyboardType: inputType,
            textInputAction: hintTxt == enterDescriptionHtml
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
    if (descriptionController.text.toString().isEmpty) {
      Utility().showToast(enterDescription);
    } else {

    }
  }
}

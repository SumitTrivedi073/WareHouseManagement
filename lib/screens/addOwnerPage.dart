import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warehouse_management_app/screens/addProductDetailPage.dart';
import 'package:warehouse_management_app/screens/model/ownerListModel.dart'
    as ownerPrefix;
import 'package:warehouse_management_app/screens/model/sourceLocModel.dart'as sourceLocPrefix;

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../utils/utility.dart';

class AddOwnerPage extends StatefulWidget {
  AddOwnerPage({Key? key}) : super(key: key);

  @override
  State<AddOwnerPage> createState() => _AddOwnerPageState();
}

class _AddOwnerPageState extends State<AddOwnerPage> {
  String? SelectOwnerType, SelectSourceLocType;
  List<ownerPrefix.Datum> selectOwnerList = [];
  List<sourceLocPrefix.Datum> selectSourceLocList = [];
  TextEditingController sourceLocController = TextEditingController();
  TextEditingController requesterController = TextEditingController();
  bool ischecked = false, isAdd = false;

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
                  ],
                ),
              )),
          nextButtonWidget()
        ]));
  }

  Widget addRemoveLocManually() {
    return GestureDetector(
        onTap: () {
          if (!isAdd) {
            isAdd = true;
          } else {
            isAdd = false;
          }
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.only(top: 10, right: 10),
          child: Align(
            alignment: Alignment.centerRight,
            child: robotoTextWidget(
                textval: isAdd ? removeLocManually : addLocManually,
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
              getSourceLocList();
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
              value: ownerlist.longName,
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
            textInputAction: hintTxt == enterRequester
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
          GestureDetector(
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

  Future<void> getSourceLocList() async {
    String data1 =
        await rootBundle.loadString('assets/api_json/sourceLocList.json');
    var jsonData1 = convert.jsonDecode(data1);
    sourceLocPrefix.SourceLocModel sourceLocModel = sourceLocPrefix.SourceLocModel.fromJson(jsonData1);
    List<sourceLocPrefix.Datum> initialList = [];
    initialList = sourceLocModel.data;
    for (sourceLocPrefix.Datum sourceLoc in initialList) {

      if (sourceLoc.ownerGuid == SelectOwnerType) {
               if(sourceLoc.longName!.isNotEmpty) {
                selectSourceLocList.add(sourceLoc);
               }

      }
    }

    setState(() {});
  }

  void moveToNextScreen() {
    SelectOwnerType ??= "";
    SelectSourceLocType ??= "";
    if (SelectOwnerType!.isEmpty) {
      SelectOwnerType = null;
      Utility().showToast(selectOwner);
    }
    if (SelectSourceLocType!.isEmpty) {
      SelectSourceLocType = null;
      Utility().showToast(selectSourceLocation);
    } else if (requesterController.text.toString().isEmpty) {
      Utility().showToast(enterRequester);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AddProductDetailPage()),
          (Route<dynamic> route) => true);
    }
  }
}

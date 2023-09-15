import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../utils/utility.dart';
import 'addproductDetail2.dart';
import 'model/categorymodel.dart' as categoryPrefix;
import 'model/makeListModel.dart' as makeListPrefix;
import 'model/subCategoryModel.dart' as subCategoryPrefix;

class AddProductDetailPage extends StatefulWidget {
  AddProductDetailPage({Key? key}) : super(key: key);

  @override
  State<AddProductDetailPage> createState() => _AddProductDetailPageState();
}

class _AddProductDetailPageState extends State<AddProductDetailPage> {
  String? SelectMakeType, SelectCategoryType, SelectSubCategoryType;
  List<makeListPrefix.Datum> selectMakeList = [];
  List<categoryPrefix.Datum> selectCategoryList = [];
  List<subCategoryPrefix.Datum> selectSubCategoryList = [];
  TextEditingController modelController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController assetsController = TextEditingController();
  TextEditingController serialNumberCodeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  String selectStatus = working;


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
                child: Column(
                  children: [
                    categorySpinnerWidget(),
                    selectSubCategorySpinnerWidget(),
                    makeSpinnerWidget(),
                    textWidget(
                        modelController, TextInputType.text, enterModelNumber),
                    textWidget(titleController, TextInputType.text, enterTitle),
                    textWidget(
                        assetsController, TextInputType.text, enterAssets),
                    textWidget(serialNumberCodeController, TextInputType.text,
                        enterSerNo),

                    textWidget(dateController, TextInputType.text,
                        enterDate),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: ListTile(
                          leading: Radio<String>(
                            activeColor: AppColor.themeColor,
                            value: working,
                            groupValue: selectStatus,
                            onChanged: (value) {
                              setState(() {
                                selectStatus = value!;
                              });
                            },
                          ),
                          title: robotoTextWidget(
                              textval: working,
                              colorval: AppColor.themeColor,
                              sizeval: 14,
                              fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                            child: ListTile(
                          leading: Radio<String>(
                            activeColor: AppColor.themeColor,
                            value: notWorking,
                            groupValue: selectStatus,
                            onChanged: (value) {
                              setState(() {
                                selectStatus = value!;
                              });
                            },
                          ),
                          title: robotoTextWidget(
                              textval: notWorking,
                              colorval: AppColor.themeColor,
                              sizeval: 14,
                              fontWeight: FontWeight.bold),
                        )),
                      ],
                    )
                  ],
                ),
              )),
          nextButtonWidget()
        ]));
  }

  categorySpinnerWidget() {
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
              hintText: selectCategory,
              fillColor: Colors.white),
          value: SelectCategoryType,
          validator: (value) =>
              value == null || value.isEmpty ? selectClassType : "",
          items: selectCategoryList
              .map((CategoryList) => DropdownMenuItem(
                  value: CategoryList.categoryId,
                  child: robotoTextWidget(
                      textval: CategoryList.category,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              SelectCategoryType = value.toString();
              SelectSubCategoryType = null;
              getSubCategoryList();
            });
          },
        ));
  }

  selectSubCategorySpinnerWidget() {
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
              hintText: selectSubCategory,
              fillColor: Colors.white),
          value: SelectSubCategoryType,
          validator: (value) =>
              value == null || value.isEmpty ? selectClassType : "",
          items: selectSubCategoryList
              .map((SubCategory) => DropdownMenuItem(
                  value: SubCategory.categorySubId,
                  child: robotoTextWidget(
                      textval: SubCategory.subCategory,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              SelectSubCategoryType = value.toString();
            });
          },
        ));
  }

  makeSpinnerWidget() {
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
              hintText: selectMakeType,
              fillColor: Colors.white),
          value: SelectMakeType,
          validator: (value) =>
              value == null || value.isEmpty ? selectClassType : "",
          items: selectMakeList
              .map((MakeList) => DropdownMenuItem(
                  value: MakeList.makeGuid,
                  child: robotoTextWidget(
                      textval: MakeList.make,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              SelectMakeType = value.toString();
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto'),
            ),
            keyboardType: inputType,
            textInputAction: hintTxt == enterDate
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
        ));
  }

  Future<void> getList() async {
    String data = await rootBundle.loadString('assets/api_json/makelist.json');
    var jsonData = convert.jsonDecode(data);
    makeListPrefix.MakeListModel makeListModel =
        makeListPrefix.MakeListModel.fromJson(jsonData);

    String data1 = await rootBundle.loadString('assets/api_json/category.json');
    var jsonData1 = convert.jsonDecode(data1);
    categoryPrefix.CategoryModel categoryModel =
        categoryPrefix.CategoryModel.fromJson(jsonData1);

    setState(() {
      selectMakeList = makeListModel.data;
      selectCategoryList = categoryModel.data;
    });
  }

  getSubCategoryList() async {
    String data2 =
        await rootBundle.loadString('assets/api_json/subcategory.json');
    var jsonData2 = convert.jsonDecode(data2);
    subCategoryPrefix.SubCategoryModel subCategoryModel =
        subCategoryPrefix.SubCategoryModel.fromJson(jsonData2);
    List<subCategoryPrefix.Datum> initialList = [];
    initialList = subCategoryModel.data;

    for (subCategoryPrefix.Datum subCategory in initialList) {
      if (subCategory.categoryId == SelectCategoryType) {
        selectSubCategoryList.add(subCategory);
      }
    }

    setState(() {});
  }

  void moveToNextScreen() {
    SelectMakeType ??= "";
    SelectCategoryType ??= "";
    SelectSubCategoryType ??= "";
    if (SelectCategoryType!.isEmpty) {
      SelectCategoryType = null;
      Utility().showToast(selectCategory);
    } else if (SelectSubCategoryType!.isEmpty) {
      SelectSubCategoryType = null;
      Utility().showToast(selectSubCategory);
    } else if (SelectMakeType!.isEmpty) {
      SelectMakeType = null;
      Utility().showToast(selectMakeType);
    } else if (modelController.text.toString().isEmpty) {
      Utility().showToast(enterModelNumber);
    } else if (titleController.text.toString().isEmpty) {
      Utility().showToast(enterTitle);
    } else if (assetsController.text.toString().isEmpty) {
      Utility().showToast(enterAssets);
    } else if (serialNumberCodeController.text.toString().isEmpty) {
      Utility().showToast(enterSerNo);
    } else if (dateController.text.toString().isEmpty) {
      Utility().showToast(enterDate);
    } else {

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const AddProductDetailPage2()),
              (Route<dynamic> route) => true);
    }
  }


/* TextEditingController serialNumberCodeController = TextEditingController();
  TextEditingController requesterCodeController = TextEditingController();
  TextEditingController itemConditionController = TextEditingController(*/
}

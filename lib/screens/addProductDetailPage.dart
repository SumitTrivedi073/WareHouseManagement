import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_management_app/screens/model/addProductModel.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import 'MakeListWidget.dart';
import 'addproductDetail2.dart';
import 'model/categorymodel.dart' as categoryPrefix;
import 'model/makeListModel.dart' as makeListPrefix;
import 'model/subCategoryModel.dart' as subCategoryPrefix;

class AddProductDetailPage extends StatefulWidget {
  AddProductDetailPage(
      {Key? key, required this.addProductModel, required this.isUpdate})
      : super(key: key);

  AddProductModel addProductModel;
  bool isUpdate;

  @override
  State<AddProductDetailPage> createState() => _AddProductDetailPageState();
}

class _AddProductDetailPageState extends State<AddProductDetailPage> {
  String? makeGuid, categoryId, categorySubId, indianFromDate, selectedDate;
  List<makeListPrefix.Datum> selectMakeList = [];
  List<makeListPrefix.Datum> glossarListOnSearch =[];
  List<categoryPrefix.Datum> selectCategoryList = [];
  List<subCategoryPrefix.Datum> selectSubCategoryList = [];

  TextEditingController modelController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController assetsController = TextEditingController();
  TextEditingController serialNumberCodeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController makeTypeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String selectStatus = working, dateTimeFormat = "dd/MM/yyyy";
  DateTime? pickedDate;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = DateFormat(dateTimeFormat).format(DateTime.now());
    indianFromDate = DateFormat(dateTimeFormat).format(DateTime.now());

    getList();
    if (widget.isUpdate) {
      modelController.text = widget.addProductModel.modelNumber ?? '';
      titleController.text = widget.addProductModel.title ?? '';
      assetsController.text = widget.addProductModel.assetDetail ?? '';
      serialNumberCodeController.text = widget.addProductModel.serialNumber ?? '';
      dateController.text = widget.addProductModel.selectedDate ?? '';
    }
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
                    makeWidget(),
                    textWidget(
                        modelController, TextInputType.text, enterModelNumber),
                    textWidget(titleController, TextInputType.text, enterTitle),
                    textWidget(
                        assetsController, TextInputType.text, enterAssets),
                    textWidget(serialNumberCodeController, TextInputType.text,
                        enterSerNo),
                    datePickerWidget(selectedDate!, dateController, selectDate),
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
          value: categoryId,
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
              categoryId = value.toString();
              categorySubId = null;
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
          value: categorySubId,
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
              categorySubId = value.toString();
            });
          },
        ));
  }

  makeWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => MakeListWidget(
                  callback: retriveMakeList,selectMakeList: selectMakeList
                )),
                (Route<dynamic> route) => true);
      },
      child: Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.themeColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                enabled: false,
                controller: makeTypeController,
                style: const TextStyle(
                    color: AppColor.themeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: selectMakeType,
                  hintStyle: const TextStyle(
                      color: AppColor.darkGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto'),
                ),
              ))),
    );
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
            textInputAction: hintTxt == enterSerNo
                ? TextInputAction.done
                : TextInputAction.next),
      ),
    );
  }

  datePickerWidget(
      String fromTO, TextEditingController DateController, String title) {
    return GestureDetector(
        onTap: () {
          _selectDate(context);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 55,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.themeColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_month,
                color: AppColor.themeColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: TextField(
                controller: DateController,
                maxLines: 1,
                showCursor: false,
                enabled: false,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    hintText: selectDate,
                    hintStyle: const TextStyle(
                        color: AppColor.darkGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto'),
                    border: InputBorder.none),
                style: const TextStyle(
                    color: AppColor.themeColor,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600),
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.done,
              ))
            ],
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));
    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat(dateTimeFormat).format(pickedDate!);
        selectedDate = DateFormat(dateTimeFormat).format(pickedDate!);
        dateController.text = formattedDate;
      });
    }
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
      if (widget.isUpdate) {
        if(widget.addProductModel.categoryId.isNotEmpty) {
          categoryId = widget.addProductModel.categoryId ?? '';
        }
        if(widget.addProductModel.makeGuid.isNotEmpty) {
          makeGuid = widget.addProductModel.makeGuid ?? '';
        }
        getSubCategoryList();
      }
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
      if (subCategory.categoryId == categoryId) {
        selectSubCategoryList.add(subCategory);
      }
    }
    if (widget.isUpdate) {
      if(widget.addProductModel.categorySubId.isNotEmpty) {
        categorySubId = widget.addProductModel.categorySubId ?? '';
      }
    }
    setState(() {});
  }

  void moveToNextScreen() {
    /*  makeGuid ??= "";
    categoryId ??= "";
    categorySubId ??= "";
    if (categoryId!.isEmpty) {
      categoryId = null;
      Utility().showToast(selectCategory);
    } else if (categorySubId!.isEmpty) {
      categorySubId = null;
      Utility().showToast(selectSubCategory);
    } else if (makeGuid!.isEmpty) {
      makeGuid = null;
      Utility().showToast(makeGuid!);
    } else if (modelController.text.toString().isEmpty) {
      Utility().showToast(enterModelNumber);
    } else if (titleController.text.toString().isEmpty) {
      Utility().showToast(enterTitle);
    } else if (assetsController.text.toString().isEmpty) {
      Utility().showToast(enterAssets);
    } else if (serialNumberCodeController.text.toString().isEmpty) {
      Utility().showToast(enterSerNo);
    } else if (dateController.text.toString().isEmpty) {
      Utility().showToast(selectDate);
    }
    else {
*/
    AddProductModel addProductModel = AddProductModel(
        ownerGuid: widget.addProductModel.ownerGuid ?? '',
        locationGuid: widget.addProductModel.locationGuid ?? '',
        requester: widget.addProductModel.requester ?? '',
        locationName: widget.addProductModel.locationName ?? '',
        countryId: widget.addProductModel.countryId ?? '',
        stateId: widget.addProductModel.stateId ?? '',
        province: widget.addProductModel.province ?? '',
        address: widget.addProductModel.address ?? '',
        city: widget.addProductModel.city ?? '',
        zipCode: widget.addProductModel.zipCode ?? '',
        categoryId: categoryId!=null&&categoryId.toString().isNotEmpty?categoryId.toString():'',
        categorySubId: categorySubId!=null&&categorySubId.toString().isNotEmpty?categorySubId.toString():'',
        makeGuid: makeGuid!=null&&makeGuid.toString().isNotEmpty?makeGuid.toString():'',
        modelNumber: modelController.text.toString().trim() ?? '',
        title: titleController.text.toString().trim() ?? '',
        assetDetail: assetsController.text.toString().trim() ?? '',
        serialNumber: serialNumberCodeController.text.toString().trim() ?? '',
        selectedDate: dateController.text.toString().trim() ?? '',
        productStatus: selectStatus.toString() ?? '',
        barcode: widget.addProductModel.barcode.toString().isNotEmpty
            ? widget.addProductModel.barcode.toString()
            : '',
        purPujNo: widget.addProductModel.purPujNo.toString().isNotEmpty
            ? widget.addProductModel.purPujNo.toString()
            : '',
        sellType: widget.addProductModel.sellType.toString().isNotEmpty
            ? widget.addProductModel.sellType.toString()
            : '',
        classType: widget.addProductModel.classType.toString().isNotEmpty
            ? widget.addProductModel.classType.toString()
            : '',
        lengthActual: widget.addProductModel.lengthActual.toString().isNotEmpty
            ? widget.addProductModel.lengthActual.toString()
            : '',
        widthActual: widget.addProductModel.widthActual.toString().isNotEmpty
            ? widget.addProductModel.widthActual.toString()
            : '',
        heightActual: widget.addProductModel.heightActual.toString().isNotEmpty
            ? widget.addProductModel.heightActual.toString()
            : '',
        lengthShipping: widget.addProductModel.lengthShipping.toString().isNotEmpty
            ? widget.addProductModel.lengthShipping.toString()
            : '',
        weightLbsActual: widget.addProductModel.weightLbsActual.toString().isNotEmpty
            ? widget.addProductModel.weightLbsActual.toString()
            : '',
        weightLbsShipping:
            widget.addProductModel.weightLbsShipping.toString().isNotEmpty
                ? widget.addProductModel.weightLbsShipping.toString()
                : '',
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
        photo5: widget.addProductModel.photo5.toString().isNotEmpty ? widget.addProductModel.photo5.toString() : '');

    print('addProductModel==================>${addProductModel.toString()}');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => AddProductDetailPage2(
                addProductModel: addProductModel, isUpdate: widget.isUpdate)),
        (Route<dynamic> route) => true);
  }



  void retriveMakeList(makeListPrefix.Datum datum) {
    setState(() {
      makeGuid = datum.makeGuid;
      print('makeGuid==========>$makeGuid');
    });
  }
}

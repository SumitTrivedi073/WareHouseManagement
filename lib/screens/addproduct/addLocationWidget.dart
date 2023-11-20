import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:REUZEIT/screens/addproduct/model/countryListModel.dart'
as countryPrefix;
import 'package:REUZEIT/screens/addproduct/model/sourceLocModel.dart'
as sourceLocPrefix;
import 'package:REUZEIT/theme/string.dart';

import '../../theme/color.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
import '../addproduct/model/addProductModel.dart';

class AddLocationWidgetPage extends StatefulWidget {
  AddLocationWidgetPage({Key? key,
    required this.callback,
    required this.addProductModel,
    required this.isUpdate})
      : super(key: key);

  AddProductModel addProductModel;
  bool isUpdate;
  final void Function(AddProductModel) callback;

  @override
  State<AddLocationWidgetPage> createState() => _AddLocationWidgetPageState();
}

class _AddLocationWidgetPageState extends State<AddLocationWidgetPage> {
  String? SelectCountryType, SelectStateType;
  List<countryPrefix.Datum> selectCountryList = [];
  List<String> selectStateList = [];
  List<sourceLocPrefix.Datum> selectSourceLocList = [];
  TextEditingController locationNameController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountryList();
    if (widget.isUpdate) {
    if(widget.addProductModel.countryId.isNotEmpty){
    SelectCountryType = widget.addProductModel.countryId;
    }

    locationNameController.text = widget.addProductModel.locationName;
    provinceController.text = widget.addProductModel.province;
    addressController.text = widget.addProductModel.address;
    cityController.text = widget.addProductModel.city;
    zipcodeController.text = widget.addProductModel.zipCode;
    getStateList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: robotoTextWidget(
              textval: addLocManually,
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    textWidget(locationNameController, TextInputType.text,
                        enterLocationName),
                    countrySpinnerWidget(),
                    stateSpinnerWidget(),
                    textWidget(
                        provinceController, TextInputType.text, enterProvince),
                    textWidget(
                        addressController, TextInputType.text, enterAddress),
                    textWidget(cityController, TextInputType.text, enterCity),
                    textWidget(
                        zipcodeController, TextInputType.text, enterZipcode),
                  ]))),
          nextButtonWidget(),
        ]));
  }

  countrySpinnerWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        height: 55,
        width: MediaQuery
            .of(context)
            .size
            .width,
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
              hintText: selectCountry,
              fillColor: Colors.white),
          value: SelectCountryType,
          validator: (value) =>
          value == null || value.isEmpty ? selectClassType : "",
          items: selectCountryList
              .map((CountryList) =>
              DropdownMenuItem(
                  value: CountryList.countryCode,
                  child: robotoTextWidget(
                      textval: CountryList.name,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              SelectCountryType = value.toString();
              SelectStateType = null;
              selectStateList = [];
              getStateList();
            });
          },
        ));
  }

  stateSpinnerWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        height: 55,
        width: MediaQuery
            .of(context)
            .size
            .width,
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
              hintText: selectState,
              fillColor: Colors.white),
          value: SelectStateType,
          validator: (value) =>
          value == null || value.isEmpty ? selectClassType : "",
          items: selectStateList
              .map((StateList) =>
              DropdownMenuItem(
                  value: StateList,
                  child: robotoTextWidget(
                      textval: StateList,
                      colorval: AppColor.themeColor,
                      sizeval: 14,
                      fontWeight: FontWeight.bold)))
              .toList(),
          onChanged: (Object? value) {
            setState(() {
              SelectStateType = value.toString();
            });
          },
        ));
  }

  Future<void> getCountryList() async {
    String data =
    await rootBundle.loadString('assets/api_json/countrylist.json');
    var jsonData = convert.jsonDecode(data);
    countryPrefix.CountryListModel countryListModel =
    countryPrefix.CountryListModel.fromJson(jsonData);
    setState(() {
      selectCountryList = countryListModel.data;
    });
  }

  Future<void> getStateList() async {
    String data1 =
    await rootBundle.loadString('assets/api_json/sourceLocList.json');
    var jsonData1 = convert.jsonDecode(data1);
    sourceLocPrefix.SourceLocModel sourceLocModel =
    sourceLocPrefix.SourceLocModel.fromJson(jsonData1);
    List<sourceLocPrefix.Datum> initialList = [];
    initialList = sourceLocModel.data;
    for (sourceLocPrefix.Datum sourceLoc in initialList) {
      if (sourceLoc.countryCode == SelectCountryType) {
        if (sourceLoc.state.isNotEmpty) {
          if (!selectStateList.contains(sourceLoc.state)) {
            setState(() {
              selectStateList.add(sourceLoc.state);
            });
            //
          }
        }
      }
    }
    if (widget.isUpdate) {
      if(widget.addProductModel.stateId.isNotEmpty) {
        SelectStateType = widget.addProductModel.stateId;
      }
    }
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
            hintTxt == enterRequester || hintTxt == enterZipcode
                ? TextInputAction.done
                : TextInputAction.next),
      ),
    );
  }

  nextButtonWidget() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
              /*SelectCountryType ??= "";
              if (locationNameController.text
                  .toString()
                  .isEmpty) {
                Utility().showToast(enterLocationName);
              } else if (SelectCountryType
                  .toString()
                  .isEmpty) {
                Utility().showToast(selectCountry);
              } else if (provinceController.text
                  .toString()
                  .isEmpty) {
                Utility().showToast(enterProvince);
              } else if (addressController.text
                  .toString()
                  .isEmpty) {
                Utility().showToast(enterAddress);
              } else if (cityController.text
                  .toString()
                  .isEmpty) {
                Utility().showToast(enterCity);
              } else if (zipcodeController.text
                  .toString()
                  .isEmpty) {
                Utility().showToast(enterZipcode);
              } else {*/
                if (widget.isUpdate) {
                  AddProductModel addProductModel = AddProductModel(
                      ownerGuid: widget.addProductModel.ownerGuid ?? '',
                      locationGuid: widget.addProductModel.locationGuid ?? '',
                      requester: widget.addProductModel.requester ?? '',
                      purPujNo: widget.addProductModel.purPujNo ?? '',
                      locationName: locationNameController.text.toString(),
                      countryId: SelectCountryType != null && SelectCountryType
                          .toString()
                          .isNotEmpty ? SelectCountryType.toString() : '',
                      stateId: SelectStateType != null && SelectStateType
                          .toString()
                          .isNotEmpty ? SelectStateType.toString() : '',
                      province: provinceController.text.toString(),
                      address: addressController.text.toString(),
                      city: cityController.text.toString(),
                      zipCode: zipcodeController.text.toString(),
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
                      lengthActual: widget.addProductModel.lengthActual ?? '',
                      widthActual: widget.addProductModel.widthActual ?? '',
                      heightActual: widget.addProductModel.heightActual ?? '',
                      lengthShipping: widget.addProductModel.lengthShipping ??
                          '',
                      weightLbsActual: widget.addProductModel.weightLbsActual ??
                          '',
                      weightLbsShipping: widget.addProductModel
                          .weightLbsShipping ?? '',
                      heightShipping: widget.addProductModel.heightShipping ?? '',
                      widthShipping: widget.addProductModel.widthShipping ?? '',
                      description: widget.addProductModel.description ?? '',
                      photo1: widget.addProductModel.photo1 ?? '',
                      photo2: widget.addProductModel.photo2 ?? '',
                      photo3: widget.addProductModel.photo3 ?? '',
                      photo4: widget.addProductModel.photo4 ?? '',
                      photo5: widget.addProductModel.photo5 ?? '',
                      isSelected: widget.addProductModel.isSelected.toString().isNotEmpty ? widget.addProductModel.isSelected.toString() : 'false');
                  widget.callback(addProductModel);
                } else {
                  AddProductModel addProductModel = AddProductModel(
                      ownerGuid: '',
                      locationGuid: '',
                      requester: '',
                      locationName: locationNameController.text.toString(),
                      countryId: SelectCountryType != null && SelectCountryType
                          .toString()
                          .isNotEmpty ? SelectCountryType.toString() : '',
                      stateId: SelectStateType!= null && SelectStateType
                          .toString()
                          .isNotEmpty ? SelectStateType.toString() : '',
                      province: provinceController.text.toString(),
                      address: addressController.text.toString(),
                      city: cityController.text.toString(),
                      zipCode: zipcodeController.text.toString(),
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
                  widget.callback(addProductModel);
                }
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
        ]));
  }
}

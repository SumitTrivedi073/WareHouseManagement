import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warehouse_management_app/main.dart';
import 'package:warehouse_management_app/screens/model/addProductModel.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../utils/utility.dart';
import 'database/database_helper.dart';
import 'image_view_widget.dart';
import 'model/imageModel.dart';

class AddImageWidgetPage extends StatefulWidget {
  AddImageWidgetPage(
      {Key? key, required this.addProductModel, required this.isUpdate})
      : super(key: key);

  AddProductModel addProductModel;
  bool isUpdate;

  @override
  State<AddImageWidgetPage> createState() => _AddImageWidgetPageState();
}

class _AddImageWidgetPageState extends State<AddImageWidgetPage> {
  List<ImageModel> imageList = [];
  List<ImageModel> itemList = [];
  var imageFile;
  int? selectedIndex, selectedPassIndex, selectedVendorPosition;
  int imgCount = 0;
  String img1 = "", img2 = "", img3 = "", img4 = "", img5 = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllImageData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColor.themeColor,
          elevation: 0,
          title: robotoTextWidget(
              textval: addImage,
              colorval: AppColor.whiteColor,
              sizeval: 15,
              fontWeight: FontWeight.w800),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColor.whiteColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Stack(children: [
          Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(children: [
                        imageList.isNotEmpty ? imageListWidget() : Container(),
                      ])))),
          nextButtonWidget(),
        ]));
  }

  imageListWidget() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: imageList.length,
            itemBuilder: (context, position) {
              return listItem(imageList[position], position);
            }));
  }

  listItem(ImageModel imageList, int position) {
    return GestureDetector(
      onTap: () {
        selectedIndex = position;
        if (imageList.imageSelected == true) {
          selectImage(context, "1");
        } else {
          selectImage(context, "0");
        }
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  robotoTextWidget(
                      textval: imageList.imageName,
                      colorval: AppColor.blackColor,
                      sizeval: 12,
                      fontWeight: FontWeight.bold),
                  SvgPicture.asset(
                    imageList.imageSelected == true
                        ? 'assets/svg/tick_icon.svg'
                        : 'assets/svg/close_icon.svg',
                    width: 20,
                    height: 20,
                  )
                ]),
          )),
    );
  }

  void selectImage(BuildContext context, String value) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return value == "0"
              ? Wrap(
                  children: <Widget>[
                    ListTile(
                      title: robotoTextWidget(
                          textval: camera,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {
                        imageSelector(context, camera),
                        Navigator.pop(context)
                      },
                    ),
                    ListTile(
                      title: robotoTextWidget(
                          textval: gallery,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {
                        imageSelector(context, gallery),
                        Navigator.pop(context)
                      },
                    ),
                    ListTile(
                      title: robotoTextWidget(
                          textval: cancel,
                          colorval: AppColor.blackColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {Navigator.pop(context)},
                    ),
                  ],
                )
              : Wrap(
                  children: <Widget>[
                    ListTile(
                      title: robotoTextWidget(
                          textval: display,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {
                        Navigator.pop(context),
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ImageView(
                                    imagepath:
                                        imageList[selectedIndex!].imagePath)),
                            (route) => true)
                      },
                    ),
                    ListTile(
                      title: robotoTextWidget(
                          textval: change,
                          colorval: AppColor.themeColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () =>
                          {Navigator.pop(context), selectImage(context, "0")},
                    ),
                    ListTile(
                      title: robotoTextWidget(
                          textval: cancel,
                          colorval: AppColor.blackColor,
                          sizeval: 12,
                          fontWeight: FontWeight.w600),
                      onTap: () => {Navigator.pop(context)},
                    ),
                  ],
                );
        });
  }

  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "Gallery":

        /// GALLERY IMAGE PICKER
        imageFile = await ImagePicker.platform.getImageFromSource(
          source: ImageSource.gallery,
        );
        break;

      case "Camera": // CAMERA CAPTURE CODE
        imageFile = await ImagePicker.platform
            .getImageFromSource(source: ImageSource.camera);
        break;
    }

    if (imageFile != null) {
      debugPrint("SELECTED IMAGE PICK   $imageFile");
      List<ImageModel> imageModel = [];
      imageModel.add(ImageModel(
          imageName: imageList[selectedIndex!].imageName,
          imagePath: imageFile.path,
          imageSelected: true));
      setState(() {
        imageList.setAll(selectedIndex!, imageModel);
      });
    } else {
      print("You have not taken image");
    }
  }

  getAllImageData() async {

      imageList.add(ImageModel(
          imageName: 'Photo1',
          imagePath: widget.addProductModel.photo1.isNotEmpty
              ? widget.addProductModel.photo1
              : '',
          imageSelected:
              widget.addProductModel.photo1.isNotEmpty ? true : false));

      imageList.add(ImageModel(
          imageName: 'Photo2',
          imagePath: widget.addProductModel.photo2.isNotEmpty
              ? widget.addProductModel.photo2
              : '',
          imageSelected:
              widget.addProductModel.photo2.isNotEmpty ? true : false));

          imageList.add(ImageModel(
          imageName: 'Photo3',
          imagePath: widget.addProductModel.photo3.isNotEmpty
              ? widget.addProductModel.photo3
              : '',
          imageSelected:
              widget.addProductModel.photo3.isNotEmpty ? true : false));

      imageList.add(ImageModel(
          imageName: 'Photo4',
          imagePath: widget.addProductModel.photo4.isNotEmpty
              ? widget.addProductModel.photo4
              : '',
          imageSelected:
              widget.addProductModel.photo4.isNotEmpty ? true : false));

          imageList.add(ImageModel(
          imageName: 'Photo5',
          imagePath: widget.addProductModel.photo5.isNotEmpty
              ? widget.addProductModel.photo5
              : '',
          imageSelected:
              widget.addProductModel.photo5.isNotEmpty ? true : false));

  }

  nextButtonWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child:  Row(
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
              dataSavedLocally();
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

        ],),
    );
  }

  void dataSavedLocally() {
    for (var i = 0; i < imageList.length; i++) {
     if(imageList[i].imageSelected){
       imgCount = i+1;
     }
    }
     print('imgCount=======>$imgCount');

/*
    if (imgCount < 2) {
      Utility().showToast(attechImages);
    } else {
*/
      if (imageList[0].imageSelected) {
        img1 = imageList[0].imagePath;
      }
      if (imageList[1].imageSelected) {
        img2 = imageList[1].imagePath;
      }
      if (imageList[2].imageSelected) {
        img3 = imageList[2].imagePath;
      }
      if (imageList[3].imageSelected) {
        img4 = imageList[3].imagePath;
      }
      if (imageList[4].imageSelected) {
        img5 = imageList[4].imagePath;
      }

      InsertUpdateDataBase();
//    }
  }

  void InsertUpdateDataBase() {
    AddProductModel addProductModel = AddProductModel(
        ownerGuid: widget.addProductModel.ownerGuid ?? '',
        locationGuid: widget.addProductModel.locationGuid ?? '',
        requester: widget.addProductModel.requester ?? '',
        locationName:  widget.addProductModel.locationName ?? '',
        countryId:  widget.addProductModel.countryId ?? '',
        stateId:  widget.addProductModel.stateId ?? '',
        province:  widget.addProductModel.province ?? '',
        address:  widget.addProductModel.address ?? '',
        city:  widget.addProductModel.city ?? '',
        zipCode: widget.addProductModel.zipCode ?? '',
        categoryId: widget.addProductModel.categoryId ?? '',
        categorySubId: widget.addProductModel.categorySubId ?? '',
        makeGuid: widget.addProductModel.makeGuid ?? '',
        modelNumber: widget.addProductModel.modelNumber ?? '',
        title: widget.addProductModel.title ?? '',
        assetDetail: widget.addProductModel.assetDetail ?? '',
        serialNumber: widget.addProductModel.serialNumber ?? '',
        selectedDate: widget.addProductModel.selectedDate ?? '',
        productStatus:widget.addProductModel.productStatus ?? '',
        barcode: widget.addProductModel.barcode ?? '',
        purPujNo: widget.addProductModel.purPujNo ?? '',
        sellType: widget.addProductModel.sellType ?? '',
        classType: widget.addProductModel.classType ?? '',
        lengthActual:widget.addProductModel.lengthActual ?? '',
        widthActual: widget.addProductModel.widthActual ?? '',
        heightActual: widget.addProductModel.heightActual ?? '',
        lengthShipping: widget.addProductModel.lengthShipping ?? '',
        weightLbsActual: widget.addProductModel.weightLbsActual ?? '',
        weightLbsShipping:widget.addProductModel.weightLbsShipping ?? '',
        description: widget.addProductModel.description,
        photo1: img1,
        photo2: img2,
        photo3: img3,
        photo4: img4,
        photo5: img5);

    print('addProductModel==================>${addProductModel.toString()}');
    if(widget.isUpdate){
      DatabaseHelper.instance.updateData(addProductModel.toMapWithoutId());
    }else {
      DatabaseHelper.instance.insertData(addProductModel.toMapWithoutId());
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(title: appName)),
        (Route<dynamic> route) => false);
  }
}

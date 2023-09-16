import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warehouse_management_app/main.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../utils/utility.dart';
import 'image_view_widget.dart';
import 'model/imageModel.dart';

class AddImageWidgetPage extends StatefulWidget {
  AddImageWidgetPage({Key? key}) : super(key: key);

  @override
  State<AddImageWidgetPage> createState() => _AddImageWidgetPageState();
}

class _AddImageWidgetPageState extends State<AddImageWidgetPage> {
  List<ImageModel> imageList = [];
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
                      ])
                  )
              )
          ),
          nextButtonWidget(),
        ])
    );
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
        if (imgCount == 0) {
          imgCount = 1;
        } else if (imgCount == 1) {
          imgCount = 2;
        }
        print('imgCount====>$imgCount');
      });
    } else {
      print("You have not taken image");
    }
  }

  getAllImageData() async {
    imageList.add(
        ImageModel(imageName: 'Photo1', imagePath: '', imageSelected: false));
    imageList.add(
        ImageModel(imageName: 'Photo2', imagePath: '', imageSelected: false));
    imageList.add(
        ImageModel(imageName: 'Photo3', imagePath: '', imageSelected: false));
    imageList.add(
        ImageModel(imageName: 'Photo4', imagePath: '', imageSelected: false));
    imageList.add(
        ImageModel(imageName: 'Photo5', imagePath: '', imageSelected: false));
  }

  nextButtonWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          dataSavedLocally();
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
                      textval: save,
                      colorval: Colors.white,
                      sizeval: 16,
                      fontWeight: FontWeight.bold),

                ],
              )),
        ),
      ),
    );
  }

  void dataSavedLocally() {
    if (imgCount < 2) {
      Utility().showToast(attechImages);
    } else {
      if (imageList[0].imageSelected) {
        img1 = Utility.getBase64FormateFile(imageList[0].imagePath);
      }
      if (imageList[1].imageSelected) {
        img2 = Utility.getBase64FormateFile(imageList[1].imagePath);
      }
      if (imageList[2].imageSelected) {
        img3 = Utility.getBase64FormateFile(imageList[2].imagePath);
      }
      if (imageList[3].imageSelected) {
        img4 = Utility.getBase64FormateFile(imageList[3].imagePath);
      }
      if (imageList[4].imageSelected) {
        img5 = Utility.getBase64FormateFile(imageList[4].imagePath);
      }

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage(title: appName)),
              (Route<dynamic> route) => true);
    }
  }
}

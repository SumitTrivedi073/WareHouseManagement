
class AddProductModel {
  String ownerGuid;
  String locationGuid;
  String requester;
  String purPujNo;
  String locationName;
  String countryId;
  String stateId;
  String province;
  String address;
  String city;
  String zipCode;
  String categoryId;
  String categorySubId;
  String makeGuid;
  String modelNumber;
  String title;
  String assetDetail;
  String serialNumber;
  String selectedDate;
  String productStatus;
  String barcode;
  String sellType;
  String classType;
  String lengthActual;
  String widthActual;
  String heightActual;
  String lengthShipping;
  String weightLbsActual;
  String weightLbsShipping;
  String description;
  String photo1;
  String photo2;
  String photo3;
  String photo4;
  String photo5;
  String isSelected;

  AddProductModel({
    required this.ownerGuid,
    required this.locationGuid,
    required this.requester,
    required this.purPujNo,
    required this.locationName,
    required this.countryId,
    required this.stateId,
    required this.province,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.categoryId,
    required this.categorySubId,
    required this.makeGuid,
    required this.modelNumber,
    required this.title,
    required this.assetDetail,
    required this.serialNumber,
    required this.selectedDate,
    required this.productStatus,
    required this.barcode,
    required this.sellType,
    required this.classType,
    required this.lengthActual,
    required this.widthActual,
    required this.heightActual,
    required this.lengthShipping,
    required this.weightLbsActual,
    required this.weightLbsShipping,
    required this.description,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
    required this.photo5,
    required this.isSelected,
  });
  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["ownerGuid"] = ownerGuid;
    map["locationGuid"] = locationGuid;
    map["requester"] = requester;
    map["purPujNo"] = purPujNo;
    map["locationName"] = locationName;
    map["countryId"] = countryId;
    map["stateId"] = stateId;
    map["province"] = province;
    map["address"] = address;
    map["city"] = city;
    map["zipCode"] = zipCode;
    map["categoryId"] = categoryId;
    map["categorySubId"] = categorySubId;
    map["makeGuid"] = makeGuid;
    map["modelNumber"] = modelNumber;
    map["title"] = title;
    map["assetDetail"] = assetDetail;
    map["serialNumber"] = serialNumber;
    map["selectedDate"] = selectedDate;
    map["productStatus"] = productStatus;
    map["barcode"] = barcode;
    map["sellType"] = sellType;
    map["classType"] = classType;
    map["lengthActual"] = lengthActual;
    map["widthActual"] = widthActual;
    map["heightActual"] = heightActual;
    map["lengthShipping"] = lengthShipping;
    map["weightLbsActual"] = weightLbsActual;
    map["weightLbsShipping"] = weightLbsShipping;
    map["description"] = description;
    map["photo1"] = photo1;
    map["photo2"] = photo2;
    map["photo3"] = photo3;
    map["photo4"] = photo4;
    map["photo5"] = photo5;
    map["isSelected"] = isSelected;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["ownerGuid"] = ownerGuid;
    map["locationGuid"] = locationGuid;
    map["requester"] = requester;
    map["purPujNo"] = purPujNo;
    map["locationName"] = locationName;
    map["countryId"] = countryId;
    map["stateId"] = stateId;
    map["province"] = province;
    map["address"] = address;
    map["city"] = city;
    map["zipCode"] = zipCode;
    map["categoryId"] = categoryId;
    map["categorySubId"] = categorySubId;
    map["makeGuid"] = makeGuid;
    map["modelNumber"] = modelNumber;
    map["title"] = title;
    map["assetDetail"] = assetDetail;
    map["serialNumber"] = serialNumber;
    map["selectedDate"] = selectedDate;
    map["productStatus"] = productStatus;
    map["barcode"] = barcode;
    map["sellType"] = sellType;
    map["classType"] = classType;
    map["lengthActual"] = lengthActual;
    map["widthActual"] = widthActual;
    map["heightActual"] = heightActual;
    map["lengthShipping"] = lengthShipping;
    map["weightLbsActual"] = weightLbsActual;
    map["weightLbsShipping"] = weightLbsShipping;
    map["description"] = description;
    map["photo1"] = photo1;
    map["photo2"] = photo2;
    map["photo3"] = photo3;
    map["photo4"] = photo4;
    map["photo5"] = photo5;
    map["isSelected"] = isSelected;

    return map;
  }

  //to be used when converting the row into object
  factory AddProductModel.fromMap(Map<String, dynamic> data) =>
      AddProductModel(
        ownerGuid: data['ownerGuid'] ?? "",
        locationGuid: data['locationGuid'] ?? "",
        requester: data['requester'] ?? "",
        purPujNo: data['purPujNo'] ?? "",
        locationName: data['locationName'] ?? "",
        countryId: data['countryId'] ?? "",
        stateId: data['stateId'] ?? "",
        province: data['province'] ?? "",
        address: data['address'] ?? "",
        city: data['city'] ?? "",
        zipCode: data['zipCode'] ?? "",
        categoryId: data['categoryId'] ?? "",
        categorySubId: data['categorySubId'] ?? "",
        makeGuid: data['makeGuid'] ?? "",
        modelNumber: data['modelNumber'] ?? "",
        title: data['title'] ?? "",
        assetDetail: data['assetDetail'] ?? "",
        serialNumber: data['serialNumber'] ?? "",
        selectedDate: data['selectedDate'] ?? "",
        productStatus: data['productStatus'] ?? "",
        barcode: data['barcode'] ?? "",
        sellType: data['sellType'] ?? "",
        classType: data['classType'] ?? "",
        lengthActual: data['lengthActual'] ?? "",
        widthActual: data['widthActual'] ?? "",
        heightActual: data['heightActual'] ?? "",
        lengthShipping: data['lengthShipping'] ?? "",
        weightLbsActual: data['weightLbsActual'] ?? "",
        weightLbsShipping: data['weightLbsShipping'] ?? "",
        description: data['description'] ?? "",
        photo1: data['photo1'] ?? "",
        photo2: data['photo2'] ?? "",
        photo3: data['photo3'] ?? "",
        photo4: data['photo4'] ?? "",
        photo5: data['photo5'] ?? "",
        isSelected: data['isSelected'] ?? 'false',
      );

  @override
  String toString() {
    return 'AddProductModel{ownerGuid: $ownerGuid, locationGuid: $locationGuid, requester: $requester, purPujNo: $purPujNo, locationName: $locationName, countryId: $countryId, stateId: $stateId, province: $province, address: $address, city: $city, zipCode: $zipCode, categoryId: $categoryId, categorySubId: $categorySubId, makeGuid: $makeGuid, modelNumber: $modelNumber, title: $title, assetDetail: $assetDetail, serialNumber: $serialNumber, selectedDate: $selectedDate, productStatus: $productStatus, barcode: $barcode, sellType: $sellType, classType: $classType, lengthActual: $lengthActual, widthActual: $widthActual, heightActual: $heightActual, lengthShipping: $lengthShipping, weightLbsActual: $weightLbsActual, weightLbsShipping: $weightLbsShipping, description: $description, photo1: $photo1, photo2: $photo2, photo3: $photo3, photo4: $photo4, photo5: $photo5, isSelected: $isSelected}';
  }
}

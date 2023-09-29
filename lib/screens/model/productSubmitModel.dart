
class ProductSubmitModel{
  String ownerGuid;
  String locationGuid;
  String requestor;
  String pickupRequestNumber;
  String categoryId;
  String categorySubId;
  String makeGuid;
  String model;
  String title;
  String assetNum;
  String serialNum;
  String mfgDate;
  String IsWorking;
  String barcode;
  String sellType;
  String productClass;
  String lengthActual;
  String lengthShipping;
  String heightActual;
  String heightShipping;
  String widthActual;
  String widthShipping;
  String weightlbsShipping;
  String weightlbsActual;
  String description;
  String images;

  ProductSubmitModel({
    required this.ownerGuid,
    required this.locationGuid,
    required this.requestor,
    required this.pickupRequestNumber,
    required this.categoryId,
    required this.categorySubId,
    required this.makeGuid,
    required this.model,
    required this.title,
    required this.assetNum,
    required this.serialNum,
    required this.mfgDate,
    required this.IsWorking,
    required this.barcode,
    required this.sellType,
    required this.productClass,
    required this.lengthActual,
    required this.lengthShipping,
    required this.heightActual,
    required this.heightShipping,
    required this.widthActual,
    required this.widthShipping,
    required this.weightlbsShipping,
    required this.weightlbsActual,
    required this.description,
    required this.images,
  });

  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["ownerGuid"] = ownerGuid;
    map["locationGuid"] = locationGuid;
    map["requestor"] = requestor;
    map["pickupRequestNumber"] = pickupRequestNumber;
    map["categoryId"] = categoryId;
    map["categorySubId"] = categorySubId;
    map["makeGuid"] = makeGuid;
    map["model"] = model;
    map["title"] = title;
    map["assetNum"] = assetNum;
    map["serialNum"] = serialNum;
    map["mfgDate"] = mfgDate;
    map["IsWorking"] = IsWorking;
    map["barcode"] = barcode;
    map["sellType"] = sellType;
    map["productClass"] = productClass;
    map["lengthActual"] = lengthActual;
    map["lengthShipping"] = lengthShipping;
    map["heightActual"] = heightActual;
    map["heightShipping"] = heightShipping;
    map["widthActual"] = widthActual;
    map["widthShipping"] = widthShipping;
    map["weightlbsShipping"] = weightlbsShipping;
    map["weightlbsActual"] = weightlbsActual;
    map["description"] = description;
    map["images"] = images;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["ownerGuid"] = ownerGuid;
    map["locationGuid"] = locationGuid;
    map["requestor"] = requestor;
    map["pickupRequestNumber"] = pickupRequestNumber;
    map["categoryId"] = categoryId;
    map["categorySubId"] = categorySubId;
    map["makeGuid"] = makeGuid;
    map["model"] = model;
    map["title"] = title;
    map["assetNum"] = assetNum;
    map["serialNum"] = serialNum;
    map["mfgDate"] = mfgDate;
    map["IsWorking"] = IsWorking;
    map["barcode"] = barcode;
    map["sellType"] = sellType;
    map["productClass"] = productClass;
    map["lengthActual"] = lengthActual;
    map["lengthShipping"] = lengthShipping;
    map["heightActual"] = heightActual;
    map["heightShipping"] = heightShipping;
    map["widthActual"] = widthActual;
    map["widthShipping"] = widthShipping;
    map["weightlbsShipping"] = weightlbsShipping;
    map["weightlbsActual"] = weightlbsActual;
    map["description"] = description;
    map["images"] = images;
    return map;
  }

  //to be used when converting the row into object
  factory ProductSubmitModel.fromMap(Map<String, dynamic> data) =>
   ProductSubmitModel(ownerGuid:  data['ownerGuid'] ?? "",
       locationGuid:  data['locationGuid'] ?? "",
       requestor:  data['requestor'] ?? "",
       pickupRequestNumber:  data['pickupRequestNumber'] ?? "",
       categoryId:  data['categoryId'] ?? "",
       categorySubId:  data['categorySubId'] ?? "",
       makeGuid:  data['makeGuid'] ?? "",
       model:  data['model'] ?? "",
       title:  data['title'] ?? "",
       assetNum:  data['assetNum'] ?? "",
       serialNum:  data['serialNum'] ?? "",
       mfgDate:  data['mfgDate'] ?? "",
       IsWorking: data["IsWorking"]??"",
       barcode:  data['barcode'] ?? "",
       sellType:  data['sellType'] ?? "",
       productClass:  data['productClass'] ?? "",
       lengthActual:  data['lengthActual'] ?? "",
       lengthShipping:  data['lengthShipping'] ?? "",
       heightActual:  data['heightActual'] ?? "",
       heightShipping:  data['heightShipping'] ?? "",
       widthActual:  data['widthActual'] ?? "",
       widthShipping:  data['widthShipping'] ?? "",
       weightlbsShipping:  data['weightlbsShipping'] ?? "",
       weightlbsActual:  data['weightlbsActual'] ?? "",
       description:  data['description'] ?? "",
       images: data['images'] ?? "");

  @override
  String toString() {
    return '{ownerGuid: $ownerGuid, locationGuid: $locationGuid, requestor: $requestor, pickupRequestNumber: $pickupRequestNumber, categoryId: $categoryId, categorySubId: $categorySubId, makeGuid: $makeGuid, model: $model, title: $title, assetNum: $assetNum, serialNum: $serialNum, mfgDate: $mfgDate,IsWorking: $IsWorking, barcode: $barcode, sellType: $sellType, productClass: $productClass, lengthActual: $lengthActual, lengthShipping: $lengthShipping, heightActual: $heightActual, heightShipping: $heightShipping, widthActual: $widthActual, widthShipping: $widthShipping, weightlbsShipping: $weightlbsShipping, weightlbsActual: $weightlbsActual, description: $description, images: $images}';
  }
}
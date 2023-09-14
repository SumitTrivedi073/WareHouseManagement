class AddProductModel {
  String classes,
      barcode,
      title,
      quantity,
      purPuj,
      retailPrice,
      modelType,
      makeType,
      serialNum,
      requester,
      itemCondition,
      owner,
      sourceLoc,
      itemLoc,
      category,
      subCategory,
      lengthActCode,
      widthAct,
      heightAct,
      lengthShipping,
      weightLbsAct,
      weightLbsShipping,
      discription,
      discriptionhtml;

  AddProductModel(
      {required this.classes,
      required this.barcode,
      required this.title,
      required this.quantity,
      required this.purPuj,
      required this.retailPrice,
      required this.modelType,
      required this.makeType,
      required this.serialNum,
      required this.requester,
      required this.itemCondition,
      required this.owner,
      required this.sourceLoc,
      required this.itemLoc,
      required this.category,
      required this.subCategory,
      required this.lengthActCode,
      required this.widthAct,
      required this.heightAct,
      required this.lengthShipping,
      required this.weightLbsAct,
      required this.weightLbsShipping,
      required this.discription,
      required this.discriptionhtml});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["classes"] = classes;
    map["barcode"] = barcode;
    map["title"] = title;
    map["quantity"] = quantity;
    map["purPuj"] = purPuj;
    map["retailPrice"] = retailPrice;
    map["modelType"] = modelType;
    map["makeType"] = makeType;
    map["serialNum"] = serialNum;
    map["requester"] = requester;
    map["itemCondition"] = itemCondition;
    map["owner"] = owner;
    map["sourceLoc"] = sourceLoc;
    map["itemLoc"] = itemLoc;
    map["category"] = category;
    map["subCategory"] = subCategory;
    map["lengthActCode"] = lengthActCode;
    map["widthAct"] = widthAct;
    map["heightAct"] = heightAct;
    map["lengthShipping"] = lengthShipping;
    map["weightLbsAct"] = weightLbsAct;
    map["weightLbsShipping"] = weightLbsShipping;
    map["discription"] = discription;
    map["discriptionhtml"] = discriptionhtml;

    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();

    map["classes"] = classes;
    map["barcode"] = barcode;
    map["title"] = title;
    map["quantity"] = quantity;
    map["purPuj"] = purPuj;
    map["retailPrice"] = retailPrice;
    map["modelType"] = modelType;
    map["makeType"] = makeType;
    map["serialNum"] = serialNum;
    map["requester"] = requester;
    map["itemCondition"] = itemCondition;
    map["owner"] = owner;
    map["sourceLoc"] = sourceLoc;
    map["itemLoc"] = itemLoc;
    map["category"] = category;
    map["subCategory"] = subCategory;
    map["lengthActCode"] = lengthActCode;
    map["widthAct"] = widthAct;
    map["heightAct"] = heightAct;
    map["lengthShipping"] = lengthShipping;
    map["weightLbsAct"] = weightLbsAct;
    map["weightLbsShipping"] = weightLbsShipping;
    map["discription"] = discription;
    map["discriptionhtml"] = discriptionhtml;
    return map;
  }

  //to be used when converting the row into object
  factory AddProductModel.fromMap(Map<String, dynamic> data) => AddProductModel(
        classes: data['classes'] ?? "",
        barcode: data['barcode'] ?? "",
        quantity: data['quantity'] ?? "",
        title: data['title'] ?? "",
        purPuj: data['purPuj'] ?? "",
        modelType: data['modelType'] ?? "",
        makeType: data['makeType'] ?? "",
        retailPrice: data['retailPrice'] ?? "",
        serialNum: data['serialNum'] ?? "",
        requester: data['requester'] ?? "",
        itemCondition: data['itemCondition'] ?? "",
        owner: data['owner'] ?? "",
        sourceLoc: data['sourceLoc'] ?? "",
        itemLoc: data['itemLoc'] ?? "",
        category: data['category'] ?? "",
        subCategory: data['subCategory'] ?? "",
        lengthActCode: data['lengthActCode'] ?? "",
        widthAct: data['widthAct'] ?? "",
        heightAct: data['heightAct'] ?? "",
        lengthShipping: data['lengthShipping'] ?? "",
        weightLbsAct: data['weightLbsAct'] ?? "",
        weightLbsShipping: data['weightLbsShipping'] ?? "",
        discription: data['discription'] ?? "",
        discriptionhtml: data['discriptionhtml'] ?? "",
      );
}

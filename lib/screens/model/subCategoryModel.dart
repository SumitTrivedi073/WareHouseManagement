// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());

class SubCategoryModel {
  List<Datum> data;

  SubCategoryModel({
    required this.data,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String categorySubId;
  String categoryId;
  String subCategory;

  Datum({
    required this.categorySubId,
    required this.categoryId,
    required this.subCategory,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    categorySubId: json["CategorySubId"]??"",
    categoryId: json["CategoryId"]??"",
    subCategory: json["SubCategory"]??"",
  );

  Map<String, dynamic> toJson() => {
    "CategorySubId": categorySubId,
    "CategoryId": categoryId,
    "SubCategory": subCategory,
  };
}

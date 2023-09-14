// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  List<Datum> data;

  CategoryModel({
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String categoryId;
  String category;
  String safeName;
  dynamic featuredProductGuid;
  String eBayCategoryId;
  String eBayUkCategoryId;
  String eBayNlCategoryId;
  String eBayDeCategoryId;
  String wooCommerceId;
  String wooCommerceNlId;

  Datum({
    required this.categoryId,
    required this.category,
    required this.safeName,
    required this.featuredProductGuid,
    required this.eBayCategoryId,
    required this.eBayUkCategoryId,
    required this.eBayNlCategoryId,
    required this.eBayDeCategoryId,
    required this.wooCommerceId,
    required this.wooCommerceNlId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    categoryId: json["CategoryId"],
    category: json["Category"],
    safeName: json["SafeName"],
    featuredProductGuid: json["FeaturedProductGUID"],
    eBayCategoryId: json["eBayCategoryId"],
    eBayUkCategoryId: json["eBayUKCategoryId"],
    eBayNlCategoryId: json["eBayNLCategoryId"],
    eBayDeCategoryId: json["eBayDECategoryId"],
    wooCommerceId: json["WooCommerceId"],
    wooCommerceNlId: json["WooCommerceNLId"],
  );

  Map<String, dynamic> toJson() => {
    "CategoryId": categoryId,
    "Category": category,
    "SafeName": safeName,
    "FeaturedProductGUID": featuredProductGuid,
    "eBayCategoryId": eBayCategoryId,
    "eBayUKCategoryId": eBayUkCategoryId,
    "eBayNLCategoryId": eBayNlCategoryId,
    "eBayDECategoryId": eBayDeCategoryId,
    "WooCommerceId": wooCommerceId,
    "WooCommerceNLId": wooCommerceNlId,
  };
}

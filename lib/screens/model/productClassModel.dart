// To parse this JSON data, do
//
//     final productClassModel = productClassModelFromJson(jsonString);

import 'dart:convert';

ProductClassModel productClassModelFromJson(String str) => ProductClassModel.fromJson(json.decode(str));

String productClassModelToJson(ProductClassModel data) => json.encode(data.toJson());

class ProductClassModel {
  List<Datum> data;

  ProductClassModel({
    required this.data,
  });

  factory ProductClassModel.fromJson(Map<String, dynamic> json) => ProductClassModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String title;

  Datum({
    required this.id,
    required this.title,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

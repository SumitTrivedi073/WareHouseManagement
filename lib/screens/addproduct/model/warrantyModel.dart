// To parse this JSON data, do
//
//     final warrantyModel = warrantyModelFromJson(jsonString);

import 'dart:convert';

WarrantyModel warrantyModelFromJson(String str) => WarrantyModel.fromJson(json.decode(str));

String warrantyModelToJson(WarrantyModel data) => json.encode(data.toJson());

class WarrantyModel {
  List<Datum> data;

  WarrantyModel({
    required this.data,
  });

  factory WarrantyModel.fromJson(Map<String, dynamic> json) => WarrantyModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String warrantyName;

  Datum({
    required this.warrantyName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    warrantyName: json["WarrantyName"],
  );

  Map<String, dynamic> toJson() => {
    "WarrantyName": warrantyName,
  };
}

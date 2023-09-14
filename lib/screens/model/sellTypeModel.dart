// To parse this JSON data, do
//
//     final sellTypeModel = sellTypeModelFromJson(jsonString);

import 'dart:convert';

SellTypeModel sellTypeModelFromJson(String str) => SellTypeModel.fromJson(json.decode(str));

String sellTypeModelToJson(SellTypeModel data) => json.encode(data.toJson());

class SellTypeModel {
  List<Datum> data;

  SellTypeModel({
    required this.data,
  });

  factory SellTypeModel.fromJson(Map<String, dynamic> json) => SellTypeModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String description;

  Datum({
    required this.id,
    required this.description,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["Id"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Description": description,
  };
}

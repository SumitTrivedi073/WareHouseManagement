// To parse this JSON data, do
//
//     final ownerListModel = ownerListModelFromJson(jsonString);

import 'dart:convert';

OwnerListModel ownerListModelFromJson(String str) => OwnerListModel.fromJson(json.decode(str));

String ownerListModelToJson(OwnerListModel data) => json.encode(data.toJson());

class OwnerListModel {
  List<Datum> data;

  OwnerListModel({
    required this.data,
  });

  factory OwnerListModel.fromJson(Map<String, dynamic> json) => OwnerListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String ownerGuid;
  String ownerName;

  Datum({
    required this.ownerGuid,
    required this.ownerName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    ownerGuid: json["OwnerGUID"],
    ownerName: json["OwnerName"],
  );

  Map<String, dynamic> toJson() => {
    "OwnerGUID": ownerGuid,
    "OwnerName": ownerName,
  };
}

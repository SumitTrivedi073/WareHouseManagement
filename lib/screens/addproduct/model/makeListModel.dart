// To parse this JSON data, do
//
//     final makeListModel = makeListModelFromJson(jsonString);

import 'dart:convert';

MakeListModel makeListModelFromJson(String str) => MakeListModel.fromJson(json.decode(str));

String makeListModelToJson(MakeListModel data) => json.encode(data.toJson());

class MakeListModel {
  List<Datum> data;

  MakeListModel({
    required this.data,
  });

  factory MakeListModel.fromJson(Map<String, dynamic> json) => MakeListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String makeGuid;
  String make;

  Datum({
    required this.makeGuid,
    required this.make,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    makeGuid: json["MakeGUID"],
    make: json["Make"],
  );

  Map<String, dynamic> toJson() => {
    "MakeGUID": makeGuid,
    "Make": make,
  };
}

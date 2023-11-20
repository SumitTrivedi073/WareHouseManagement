// To parse this JSON data, do
//
//     final includeListModel = includeListModelFromJson(jsonString);

import 'dart:convert';

IncludeListModel includeListModelFromJson(String str) => IncludeListModel.fromJson(json.decode(str));

String includeListModelToJson(IncludeListModel data) => json.encode(data.toJson());

class IncludeListModel {
  List<Datum> data;

  IncludeListModel({
    required this.data,
  });

  factory IncludeListModel.fromJson(Map<String, dynamic> json) => IncludeListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String includes;

  Datum({
    required this.includes,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    includes: json["Includes"],
  );

  Map<String, dynamic> toJson() => {
    "Includes": includes,
  };
}

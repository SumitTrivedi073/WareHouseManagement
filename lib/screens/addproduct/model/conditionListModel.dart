// To parse this JSON data, do
//
//     final conditionListModel = conditionListModelFromJson(jsonString);

import 'dart:convert';

ConditionListModel conditionListModelFromJson(String str) => ConditionListModel.fromJson(json.decode(str));

String conditionListModelToJson(ConditionListModel data) => json.encode(data.toJson());

class ConditionListModel {
  List<Datum> data;

  ConditionListModel({
    required this.data,
  });

  factory ConditionListModel.fromJson(Map<String, dynamic> json) => ConditionListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String condition;

  Datum({
    required this.condition,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    condition: json["Condition"],
  );

  Map<String, dynamic> toJson() => {
    "Condition": condition,
  };
}

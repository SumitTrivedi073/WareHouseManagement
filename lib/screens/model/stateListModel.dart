// To parse this JSON data, do
//
//     final StateListModel = StateListModelFromJson(jsonString);

import 'dart:convert';

StateListModel StateListModelFromJson(String str) => StateListModel.fromJson(json.decode(str));

String StateListModelToJson(StateListModel data) => json.encode(data.toJson());

class StateListModel {
  List<Datum> data;

  StateListModel({
    required this.data,
  });

  factory StateListModel.fromJson(Map<String, dynamic> json) => StateListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String name;

  Datum({
    required this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
  };
}

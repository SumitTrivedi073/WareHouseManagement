// To parse this JSON data, do
//
//     final countryListModel = countryListModelFromJson(jsonString);

import 'dart:convert';

CountryListModel countryListModelFromJson(String str) => CountryListModel.fromJson(json.decode(str));

String countryListModelToJson(CountryListModel data) => json.encode(data.toJson());

class CountryListModel {
  List<Datum> data;

  CountryListModel({
    required this.data,
  });

  factory CountryListModel.fromJson(Map<String, dynamic> json) => CountryListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String name;
  String countryCode;

  Datum({
    required this.name,
    required this.countryCode,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["Name"],
    countryCode: json["CountryCode"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "CountryCode": countryCode,
  };
}

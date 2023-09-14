// To parse this JSON data, do
//
//     final sourceLocModel = sourceLocModelFromJson(jsonString);

import 'dart:convert';

SourceLocModel sourceLocModelFromJson(String str) => SourceLocModel.fromJson(json.decode(str));

String sourceLocModelToJson(SourceLocModel data) => json.encode(data.toJson());

class SourceLocModel {
  List<Datum> data;

  SourceLocModel({
    required this.data,
  });

  factory SourceLocModel.fromJson(Map<String, dynamic> json) => SourceLocModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String locationGuid;
  String ownerGuid;
  String? longName;
  String archive;
  String countryCode;
  String state;
  String field7;
  String field8;

  Datum({
    required this.locationGuid,
    required this.ownerGuid,
    required this.longName,
    required this.archive,
    required this.countryCode,
    required this.state,
    required this.field7,
    required this.field8,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    locationGuid: json["LocationGUID"]??"",
    ownerGuid: json["OwnerGUID"]??"",
    longName: json["LongName"]??"",
    archive: json["Archive"]??"",
    countryCode: json["CountryCode"]??"",
    state: json["State"]??"",
    field7: json["FIELD7"]??"",
    field8: json["FIELD8"]??"",
  );

  Map<String, dynamic> toJson() => {
    "LocationGUID": locationGuid,
    "OwnerGUID": ownerGuid,
    "LongName": longName,
    "Archive": archive,
    "CountryCode": countryCode,
    "State": state,
    "FIELD7": field7,
    "FIELD8": field8,
  };
}


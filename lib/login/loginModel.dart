// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';


LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  List<Datum> data;

  LoginModel({
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String result;
  String reason;
  String userGuid;

  Datum({
    required this.result,
    required this.reason,
    required this.userGuid,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    result: json["Result"],
    reason: json["Reason"],
    userGuid: json["UserGUID"],
  );

  Map<String, dynamic> toJson() => {
    "Result": result,
    "Reason": reason,
    "UserGUID": userGuid,
  };
}

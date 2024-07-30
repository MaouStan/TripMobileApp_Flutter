// To parse this JSON data, do
//
//     final customerPostLoginReq = customerPostLoginReqFromJson(jsonString);

import 'dart:convert';

CustomerPostLoginReq customerPostLoginReqFromJson(String str) => CustomerPostLoginReq.fromJson(json.decode(str));

String customerPostLoginReqToJson(CustomerPostLoginReq data) => json.encode(data.toJson());

class CustomerPostLoginReq {
    String phone;
    String password;

    CustomerPostLoginReq({
        required this.phone,
        required this.password,
    });

    factory CustomerPostLoginReq.fromJson(Map<String, dynamic> json) => CustomerPostLoginReq(
        phone: json["phone"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "phone": phone,
        "password": password,
    };
}

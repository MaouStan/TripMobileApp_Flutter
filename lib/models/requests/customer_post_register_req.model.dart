// To parse this JSON data, do
//
//     final customerPostRegisterReq = customerPostRegisterReqFromJson(jsonString);

import 'dart:convert';

CustomerPostRegisterReq customerPostRegisterReqFromJson(String str) => CustomerPostRegisterReq.fromJson(json.decode(str));

String customerPostRegisterReqToJson(CustomerPostRegisterReq data) => json.encode(data.toJson());

class CustomerPostRegisterReq {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomerPostRegisterReq({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomerPostRegisterReq.fromJson(Map<String, dynamic> json) => CustomerPostRegisterReq(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}

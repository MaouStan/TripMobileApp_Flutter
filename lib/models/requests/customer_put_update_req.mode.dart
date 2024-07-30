// To parse this JSON data, do
//
//     final customerReq = customerReqFromJson(jsonString);

import 'dart:convert';

CustomerReq customerReqFromJson(String str) => CustomerReq.fromJson(json.decode(str));

String customerReqToJson(CustomerReq data) => json.encode(data.toJson());

class CustomerReq {
    String fullname;
    String phone;
    String email;
    String image;

    CustomerReq({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CustomerReq.fromJson(Map<String, dynamic> json) => CustomerReq(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}

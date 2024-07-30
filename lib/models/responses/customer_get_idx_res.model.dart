// To parse this JSON data, do
//
//     final customerRes = customerResFromJson(jsonString);

import 'dart:convert';

CustomerRes customerResFromJson(String str) => CustomerRes.fromJson(json.decode(str));

String customerResToJson(CustomerRes data) => json.encode(data.toJson());

class CustomerRes {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    CustomerRes({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CustomerRes.fromJson(Map<String, dynamic> json) => CustomerRes(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}

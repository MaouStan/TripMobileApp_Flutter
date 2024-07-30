// To parse this JSON data, do
//
//     final customersRes = customersResFromJson(jsonString);

import 'dart:convert';

List<CustomersRes> customersResFromJson(String str) => List<CustomersRes>.from(json.decode(str).map((x) => CustomersRes.fromJson(x)));

String customersResToJson(List<CustomersRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomersRes {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    CustomersRes({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CustomersRes.fromJson(Map<String, dynamic> json) => CustomersRes(
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

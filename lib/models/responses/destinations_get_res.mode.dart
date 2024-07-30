// To parse this JSON data, do
//
//     final destinationsGetResponse = destinationsGetResponseFromJson(jsonString);

import 'dart:convert';

List<DestinationsGetResponse> destinationsGetResponseFromJson(String str) => List<DestinationsGetResponse>.from(json.decode(str).map((x) => DestinationsGetResponse.fromJson(x)));

String destinationsGetResponseToJson(List<DestinationsGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DestinationsGetResponse {
  int idx;
  String zone;

  DestinationsGetResponse({
    required this.idx,
    required this.zone,
  });

  factory DestinationsGetResponse.fromJson(Map<String, dynamic> json) => DestinationsGetResponse(
        idx: json["idx"],
        zone: json["zone"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "zone": zone,
      };
}

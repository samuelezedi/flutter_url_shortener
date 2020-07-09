import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

 Links clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Links.fromMap(jsonData);
}

String linksToJson(Links data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Links {
  int id;
  String long;
  String short;
  String api;
  Timestamp created;

  Links({
    this.id,
    this.long,
    this.short,
    this.api,
    this.created
  });

  factory Links.fromMap(Map<String, dynamic> json) => new Links(
    id: json["id"],
    long: json["long"],
    short: json["short"],
    api: json["api"],
    created: json['date_created']
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "long": long,
    "short": short,
    "api": api,
    "date_created" : created
  };
}
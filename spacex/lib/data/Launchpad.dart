// ignore: non_constant_identifier_names

import 'package:flutter/material.dart';

class Launchpad {
  final String id;
  final String name;
  final String full_name;
  final String region;
  final String details;

  Launchpad({
    @required this.id,
    @required this.name,
    @required this.full_name,
    @required this.region,
    @required this.details,
  });

  factory Launchpad.fromJson(Map<String, dynamic> json) {
    return Launchpad(
      id: json['id'],
      name: json['name'],
      full_name: json['full_name'],
      region: json['region'],
      details: json['details'],
    );
  }
}

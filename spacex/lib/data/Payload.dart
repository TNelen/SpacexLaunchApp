// ignore: non_constant_identifier_names

import 'package:flutter/material.dart';

class Payload {
  final String id;
  final String name;
  final String type;
  final String orbit;
  final String reference_system;

  Payload({
    @required this.id,
    @required this.name,
    @required this.type,
    @required this.orbit,
    @required this.reference_system,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      orbit: json['orbit'],
      reference_system: json['reference_system'],
    );
  }
}

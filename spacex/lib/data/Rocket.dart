// ignore: non_constant_identifier_names

import 'package:flutter/material.dart';

class Rocket {
  final String id;
  final String description;
  final dynamic height;
  final double diameter;
  final int mass;
  final String name;
  final int stages;

  Rocket({
    @required this.id,
    @required this.description,
    @required this.height,
    @required this.diameter,
    @required this.mass,
    @required this.name,
    @required this.stages,
  });

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
      id: json['id'],
      description: json['description'],
      height: json['height']['meters'],
      diameter: json['diameter']['meters'],
      mass: json['mass']['kg'],
      name: json['name'],
      stages: json['stages'],
    );
  }
}

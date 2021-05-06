// ignore: non_constant_identifier_names

import 'package:flutter/material.dart';

class Launch {
  final String id;
  final bool success;
  final String name;
  final String date_utc;
  final String details;
  final String patchLink;
  final int flight_number;
  final List<dynamic> crew;
  final List<dynamic> payloads;
  final String launchpad;
  final String rocket;
  final String webcast;
  final String article;
  final String date_precision;
  final bool recovery;
  final bool reused;

  Launch({
    @required this.id,
    @required this.success,
    @required this.name,
    @required this.date_utc,
    @required this.details,
    @required this.patchLink,
    @required this.flight_number,
    @required this.crew,
    @required this.payloads,
    @required this.launchpad,
    @required this.rocket,
    @required this.webcast,
    @required this.article,
    @required this.date_precision,
    @required this.recovery,
    @required this.reused,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      id: json['id'],
      success: json['success'],
      name: json['name'],
      date_utc: json['date_utc'],
      details: json['details'],
      patchLink: json['links']['patch']['large'],
      flight_number: json['flight_number'],
      crew: json['crew'],
      payloads: json['payloads'],
      launchpad: json['launchpad'],
      rocket: json['rocket'],
      webcast: json['links']['webcast'],
      article: json['links']['article'],
      date_precision: json['date_precision'],
      recovery: json['cores'][0]['landing_attempt'],
      reused: json['cores'][0]['reused'],
    );
  }
}

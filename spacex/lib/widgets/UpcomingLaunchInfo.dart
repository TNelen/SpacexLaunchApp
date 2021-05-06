import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:spacex/Queries/API.dart';
import 'package:spacex/data/Launch.dart';
import 'package:intl/intl.dart';
import 'package:spacex/data/Launchpad.dart';
import 'package:spacex/data/Payload.dart';
import 'package:spacex/data/Rocket.dart';
import 'package:spacex/data/Tminus.dart';
import 'package:spacex/widgets/Curves.dart';

import '../Constants.dart';

class UpcomingLaunchInfo extends StatefulWidget {
  final Launch launch;

  UpcomingLaunchInfo({this.launch});

  @override
  State<StatefulWidget> createState() {
    return UpcomingLaunchInfoState();
  }
}

class UpcomingLaunchInfoState extends State<UpcomingLaunchInfo> {
  var padinfo = new Launchpad();
  var rocketinfo = new Rocket();
  var payloads = new List<Payload>();

  _getRocketinfo() {
    API.getRocket(widget.launch.rocket).then((response) {
      setState(() {
        rocketinfo = Rocket.fromJson(json.decode(response.body));
      });
    });
  }

  _getLaunchpadInfo() {
    API.getLaunchpad(widget.launch.launchpad).then((response) {
      setState(() {
        padinfo = Launchpad.fromJson(json.decode(response.body));
      });
    });
  }

  _getPayloadInfo() {
    for (String pl in widget.launch.payloads) {
      API.getPayload(pl).then((response) {
        setState(() {
          payloads.add(Payload.fromJson(json.decode(response.body)));
        });
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getLaunchpadInfo();
    _getRocketinfo();
    _getPayloadInfo();
  }

  @override
  dispose() {
    super.dispose();
  }

  List<Widget> buildPayloadText() {
    var list = new List<Widget>();
    for (Payload pl in payloads) {
      list.add(Text(
        pl.type,
        style: TextStyle(
            fontSize: 12, color: Constants.grey, fontWeight: FontWeight.w400),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 10),
              child: Text(
                "#" + widget.launch.flight_number.toString(),
                style: TextStyle(
                                                    fontFamily: 'Oxanium',

                    fontSize: 15,
                    color: Constants.grey,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          CustomPaint(
            painter: InforCurve(),
          ),
          (rocketinfo.description != null && padinfo.full_name != null)
              ? Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.launch.patchLink != null
                            ? Image.network(
                                widget.launch.patchLink,
                                width: 150,
                                height: 150,
                                fit: BoxFit.contain,
                              )
                            : Stack(alignment: Alignment.center, children: [
                                Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                    color: Constants.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Image.asset(
                                  "images/rocket.png",
                                  height: 80,
                                  width: 80,
                                  color: Constants.accent,
                                  fit: BoxFit.contain,
                                )
                              ]),
                        Text(
                          widget.launch.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 25,
                              color: Constants.white,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Card(
                          elevation: 0,
                          color: Constants.tile,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 3, right: 3, top: 6, bottom: 6),
                            child: Text(
                              (widget.launch.date_precision == "day" ||
                                      widget.launch.date_precision == "hour")
                                  ? "Go for launch!"
                                  : "To be confirmed",
                              style: TextStyle(
                                  fontFamily: "Oxanium",
                                  fontSize: 18,
                                  color:
                                      (widget.launch.date_precision == "day" ||
                                              widget.launch.date_precision ==
                                                  "hour")
                                          ? Constants.success
                                          : Constants.failure,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Text(
                          DateFormat.yMMMMd('en_US').format(
                              DateTime.parse(widget.launch.date_utc).toLocal()),
                          style: TextStyle(
                              fontFamily: "Oxanium",
                              fontSize: 15,
                              color: Constants.white.withOpacity(0.5),
                              fontWeight: FontWeight.w400),
                        ),
                        Card(
                          elevation: 0,
                          color: Constants.darkgrey,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 3, right: 3, top: 6, bottom: 6),
                            child: Container(
                              width: 300,
                              child: AutoSizeText(
                                "T -  " +
                                    Tminus().calculateTminusNoSec(
                                        widget.launch.date_utc),
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontSize: 25,
                                    color: Constants.white,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Launch Site",
                              style: TextStyle(
                                  fontFamily: 'Oxanium',
                                  fontSize: 17,
                                  color: Constants.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              padinfo.full_name,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constants.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              padinfo.region,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constants.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Rocket",
                              style: TextStyle(
                                  fontFamily: 'Oxanium',
                                  fontSize: 17,
                                  color: Constants.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              rocketinfo.name,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constants.grey,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Payload",
                              style: TextStyle(
                                  fontFamily: 'Oxanium',
                                  fontSize: 17,
                                  color: Constants.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            payloads != null || payloads.length != 0
                                ? Container(
                                    width: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildPayloadText(),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
              : Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlowingProgressIndicator(
                          child: Image.asset(
                            "images/rocket.png",
                            width: 60,
                            height: 60,
                            color: Constants.accent,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Loading launch info",
                          style: TextStyle(
                              fontFamily: 'Spacex',
                              fontSize: 15,
                              color: Constants.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
        ]);
  }
}

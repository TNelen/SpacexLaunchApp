import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:spacex/Queries/API.dart';
import 'package:spacex/data/Launch.dart';
import 'package:intl/intl.dart';
import 'package:spacex/data/Launchpad.dart';
import 'package:spacex/data/Payload.dart';
import 'package:spacex/data/Rocket.dart';
import 'package:spacex/widgets/Curves.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants.dart';

class PreviousLaunchInfo extends StatefulWidget {
  final Launch launch;

  PreviousLaunchInfo({this.launch});

  @override
  State<StatefulWidget> createState() {
    return PreviousLaunchInfoState();
  }
}

class PreviousLaunchInfoState extends State<PreviousLaunchInfo> {
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

  initState() {
    super.initState();
    _getLaunchpadInfo();
    _getRocketinfo();
    _getPayloadInfo();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> buildPayloadText() {
    var list = new List<Widget>();
    for (Payload pl in payloads) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            pl.name + ":   ",
            style: TextStyle(
                fontSize: 12,
                color: Constants.grey,
                fontWeight: FontWeight.w400),
          ),
          Text(
            pl.type,
            style: TextStyle(
                fontSize: 12,
                color: Constants.grey,
                fontWeight: FontWeight.w400),
          )
        ],
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
                            : SizedBox(
                                width: 150,
                                height: 150,
                              ),
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
                          color: widget.launch.success
                              ? Constants.success
                              : Constants.failure,
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(
                              widget.launch.success ? "Success" : "Failure",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Oxanium',
                                  color: Constants.darkgrey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                "Description",
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
                                widget.launch.details,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 15,
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
                                height: 5,
                              ),
                              Text(
                                widget.launch.reused
                                    ? "Reused: Yes"
                                    : "Reused: No",
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
                                        children: buildPayloadText(),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Media",
                                style: TextStyle(
                                    fontFamily: 'Oxanium',
                                    fontSize: 17,
                                    color: Constants.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Webcast",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Constants.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      widget.launch.webcast != null
                                          ? Card(
                                              elevation: 0,
                                              color: Constants.tile,
                                              child: Padding(
                                                  padding: EdgeInsets.all(3),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .ondemand_video_outlined,
                                                      size: 17,
                                                      color: Constants.accent,
                                                    ),
                                                    onPressed: () {
                                                      _launchInBrowser(widget
                                                          .launch.webcast);
                                                    },
                                                  )),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  widget.launch.article != null
                                      ? Row(
                                          children: [
                                            Text(
                                              "Article",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Constants.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Card(
                                              elevation: 0,
                                              color: Constants.tile,
                                              child: Padding(
                                                  padding: EdgeInsets.all(3),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.article_outlined,
                                                      size: 17,
                                                      color: Constants.accent,
                                                    ),
                                                    onPressed: () {
                                                      _launchInBrowser(widget
                                                          .launch.article);
                                                    },
                                                  )),
                                            )
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              )
                            ],
                          ),
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

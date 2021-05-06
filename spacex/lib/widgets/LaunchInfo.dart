import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacex/Queries/API.dart';
import 'package:spacex/data/Launch.dart';
import 'package:spacex/data/Launchpad.dart';
import 'package:spacex/data/Rocket.dart';
import 'package:spacex/widgets/Curves.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants.dart';

class LaunchInfo extends StatefulWidget {
  final Launch launch;

  LaunchInfo({this.launch});

  @override
  State<StatefulWidget> createState() {
    return LaunchInfoState();
  }
}

class LaunchInfoState extends State<LaunchInfo> {
  var padinfo = new Launchpad();
  var rocketinfo = new Rocket();
  var connection = CONNECTIONSTATE.LOADING;

  _setStatus(int status) {
    if (status == 200) {
      connection = CONNECTIONSTATE.SUCCESS;
    } else if (status == 502 || status == 503) {
      connection = CONNECTIONSTATE.TIMEOUT;
    } else {
      connection = CONNECTIONSTATE.LOADING;
    }
  }

  _getRocketinfo() {
    API.getRocket(widget.launch.rocket).then((response) {
      setState(() {
        _setStatus(response.statusCode);
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

  initState() {
    super.initState();
    _getLaunchpadInfo();
    _getRocketinfo();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
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
                              fontSize: 25,
                              color: Constants.white,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
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
                                  color: Constants.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Launch Site",
                              style: TextStyle(
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
                                  color: Constants.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              padinfo.region,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constants.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Rocket",
                              style: TextStyle(
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
                                  color: Constants.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              rocketinfo.description,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constants.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "#" +
                                        widget.launch.flight_number.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Constants.white.withOpacity(0.3),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ])),
                        Expanded(
                            flex: 1,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.launch.webcast != null
                                      ? Card(
                                          elevation: 0,
                                          color: Constants.tile,
                                          child: Padding(
                                              padding: EdgeInsets.all(3),
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.ondemand_video_outlined,
                                                  size: 17,
                                                  color: Constants.accent,
                                                ),
                                                onPressed: () {
                                                  _launchInBrowser(
                                                      widget.launch.webcast);
                                                },
                                              )),
                                        )
                                      : SizedBox(),
                                ])),
                      ],
                    ),
                  ))
              : Center(
                  child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()))
        ]);
  }
}

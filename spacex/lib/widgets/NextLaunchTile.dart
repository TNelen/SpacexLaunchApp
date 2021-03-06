import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spacex/data/Launch.dart';
import 'package:intl/intl.dart';
import 'package:spacex/data/Launchpad.dart';
import 'package:spacex/data/Payload.dart';
import 'package:spacex/data/Rocket.dart';
import 'package:spacex/data/Tminus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants.dart';
import 'UpcomingLaunchInfo.dart';

class NextLaunchTile extends StatefulWidget {
  final Launch launch;
  final Launchpad pad;
  final Rocket rocket;
  final Payload payload;

  NextLaunchTile({this.launch, this.pad, this.rocket, this.payload});

  @override
  State<StatefulWidget> createState() {
    return NextLaunchTileState();
  }
}

class NextLaunchTileState extends State<NextLaunchTile> {
  @override
  void initState() {}

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Constants.tile,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          //open info page
          showBarModalBottomSheet(
            context: context,
            builder: (context) => Container(
              child: UpcomingLaunchInfo(
                launch: widget.launch,
              ),
              color: Constants.tile,
            ),
          );
        },
        splashColor: Constants.tile,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: widget.launch.patchLink != null
                          ? Image.network(
                              widget.launch.patchLink,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            )
                          : Stack(alignment: Alignment.center, children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: new BoxDecoration(
                                  color: Constants.darkgrey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Image.asset(
                                "images/rocket.png",
                                height: 40,
                                width: 40,
                                color: Constants.accent,
                                fit: BoxFit.contain,
                              )
                            ]),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.launch.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Oxanium',
                              fontSize: 22,
                              color: Constants.white,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            DateFormat.yMMMMd('en_US').format(
                                DateTime.parse(widget.launch.date_utc)
                                    .toLocal()),
                            style: TextStyle(
                                fontFamily: "Oxanium",
                                fontSize: 15,
                                color: Constants.white.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "#" + widget.launch.flight_number.toString(),
                        style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 15,
                            color: Constants.grey,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 220,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 216,
                          height: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Launch site: ",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.pad.name,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 216,
                          height: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Payload: ",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.payload.type,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 216,
                          height: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rocket: ",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.rocket.name,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 216,
                          height: 18,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Landing attempt: ",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.launch.recovery == true
                                    ? "Yes"
                                    : widget.launch.recovery == null
                                        ? "Unknown"
                                        : "No",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  elevation: 0,
                  color: Constants.darkgrey,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 3, right: 3, top: 6, bottom: 6),
                    child: Container(
                      width: 210,
                      child: Text(
                        Tminus().calculateTminus(widget.launch.date_utc),
                        style: TextStyle(
                            fontFamily: 'Oxanium',
                            fontSize: 15,
                            color: Constants.accent,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                widget.launch.webcast != null
                    ? InkWell(
                        onTap: () {
                          _launchInBrowser(widget.launch.webcast);
                        },
                        child: Container(
                          width: 216,
                          height: 15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Webcast: ",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Constants.grey,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.ondemand_video_outlined,
                                size: 17,
                                color: Constants.accent,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 216,
                        height: 15,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spacex/data/Launch.dart';
import 'package:intl/intl.dart';
import 'package:spacex/widgets/UpcomingLaunchInfo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants.dart';

class UpcomingLaunchTile extends StatefulWidget {
  final Launch launch;
  final bool upcoming;

  UpcomingLaunchTile({this.launch, this.upcoming});

  @override
  State<StatefulWidget> createState() {
    return UpcomingLaunchTileState();
  }
}

class UpcomingLaunchTileState extends State<UpcomingLaunchTile> {
  static bool confirmed = false;

  @override
  void initState() {
    confirmed = (widget.launch.date_precision == "day" ||
            widget.launch.date_precision == "hour")
        ? true
        : false;
    super.initState();
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
    return Card(
      elevation: 1,
      color: Constants.tile,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          //open info page
          showBarModalBottomSheet(
            elevation: 5,
            context: context,
            builder: (context) => Container(
              child: UpcomingLaunchInfo(
                launch: widget.launch,
              ),
              color: Constants.tile,
            ),
          );
        },
        onLongPress: () {},
        splashColor: Constants.tile,
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.launch.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontSize: 17,
                        color: Constants.white,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            DateFormat.yMMMMd('en_US').add_jm().format(
                                DateTime.parse(widget.launch.date_utc)
                                    .toLocal()),
                            style: TextStyle(
                                fontFamily: "Oxanium",
                                fontSize: 13,
                                color: Constants.white.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Card(
                          elevation: 0,
                          color: (widget.launch.date_precision == "day" ||
                                  widget.launch.date_precision == "hour")
                              ? Constants.success
                              : Constants.failure,
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(
                              (widget.launch.date_precision == "day" ||
                                      widget.launch.date_precision == "hour")
                                  ? "Go!"
                                  : "TBC",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Constants.darkgrey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ]),
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
                                  _launchInBrowser(widget.launch.webcast);
                                },
                              )),
                        )
                      : SizedBox(),
                ],
              )),
        ),
      ),
    );
  }
}

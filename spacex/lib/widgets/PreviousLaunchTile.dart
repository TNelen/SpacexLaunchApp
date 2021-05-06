import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spacex/data/Launch.dart';
import 'package:intl/intl.dart';
import 'package:spacex/widgets/LaunchInfo.dart';
import 'package:spacex/widgets/PreviousLaunchInfo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants.dart';

class PreviousLaunchTile extends StatefulWidget {
  final Launch launch;
  final bool upcoming;

  PreviousLaunchTile({this.launch, this.upcoming});

  @override
  State<StatefulWidget> createState() {
    return PreviousLaunchTileState();
  }
}

class PreviousLaunchTileState extends State<PreviousLaunchTile> {
  @override
  void initState() {}

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
            context: context,
            builder: (context) => Container(
              child: PreviousLaunchInfo(
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
            padding: const EdgeInsets.all(6.0),
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
                          : SizedBox(
                              width: 80,
                              height: 80,
                            ),
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
                                fontSize: 17,
                                color: Constants.white,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 3,
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
                                    fontFamily: 'Oxanium',
                                    fontSize: 12,
                                    color: Constants.darkgrey,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

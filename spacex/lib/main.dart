import 'dart:async';
import 'dart:convert';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:spacex/Constants.dart';
import 'package:spacex/widgets/Curves.dart';
import 'package:spacex/widgets/NextLaunchTile.dart';
import 'package:spacex/widgets/PreviousLaunchTile.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:spacex/widgets/UpcomingLaunchTile.dart';

import 'Queries/API.dart';
import 'data/Launch.dart';
import 'data/Launchpad.dart';
import 'data/Payload.dart';
import 'data/Rocket.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Constants.background,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var upcomingLaunches = new List<Launch>();
  var pastLaunches = new List<Launch>();
  var nextLaunch = new Launch();
  var nextLaunchSite = new Launchpad();
  var nextRocket = new Rocket();
  var nextPayload = new Payload();
  var connection = CONNECTIONSTATE.LOADING;
  Timer refreshtimer;

  _setStatus(int status) {
    if (status == 200) {
      connection = CONNECTIONSTATE.SUCCESS;
    } else if (status == 522 || status == 503) {
      connection = CONNECTIONSTATE.TIMEOUT;
    } else {
      connection = CONNECTIONSTATE.LOADING;
    }
  }

  _getUpcomingLaunches() {
    API.getUpcomingLaunches().then((response) {
      setState(() {
        print(response.statusCode);
        Iterable list = json.decode(response.body);
        upcomingLaunches = list.map((model) => Launch.fromJson(model)).toList();
      });
    });
  }

  _getPastLaunches() {
    API.getPastLaunches().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        pastLaunches = list.map((model) => Launch.fromJson(model)).toList();
      });
    });
  }

  _getNextLaunch() {
    API.getNextLaunch().then((response) {
      setState(() {
        nextLaunch = Launch.fromJson(json.decode(response.body));
      });
      API.getLaunchpad(nextLaunch.launchpad).then(
        (response2) {
          setState(() {
            nextLaunchSite = Launchpad.fromJson(json.decode(response2.body));
          });
          API.getRocket(nextLaunch.rocket).then(
            (response3) {
              setState(() {
                nextRocket = Rocket.fromJson(json.decode(response3.body));
              });
              API.getPayload(nextLaunch.payloads[0]).then(
                (response4) {
                  setState(
                    () {
                      nextPayload =
                          Payload.fromJson(json.decode(response4.body));
                      _setStatus(response4.statusCode);
                    },
                  );
                },
              );
            },
          );
        },
      );
    });
  }

  @override
  initState() {
    super.initState();
    connection = CONNECTIONSTATE.LOADING;
    _getUpcomingLaunches();
    _getPastLaunches();
    _getNextLaunch();
    refreshtimer = new Timer.periodic(seconds(1), (Timer t) => setState(() {}));
  }

  @override
  dispose() {
    refreshtimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.background,
      body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              painter: MainscreenCurve(),
            ),
            (connection == CONNECTIONSTATE.SUCCESS)
                ? Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "SpaceX ",
                                style: TextStyle(
                                    fontFamily: 'Spacex',
                                    fontSize: 25,
                                    color: Constants.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Image.asset(
                                "images/rocket.png",
                                width: 20,
                                height: 20,
                                color: Constants.accent,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                " Launches",
                                style: TextStyle(
                                    fontFamily: 'Spacex',
                                    fontSize: 25,
                                    color: Constants.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ]),
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
                              height: 210,
                              child: NextLaunchTile(
                                launch: upcomingLaunches[0],
                                rocket: nextRocket,
                                pad: nextLaunchSite,
                                payload: nextPayload,
                              ))),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(1.0),
                          child: ContainedTabBarView(
                            tabBarProperties: TabBarProperties(
                                indicatorColor: Constants.accent,
                                indicatorPadding:
                                    EdgeInsets.only(left: 30, right: 30)),
                            tabs: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Previous',
                                      style: TextStyle(
                                          fontFamily: 'Oxanium',
                                          fontSize: 17,
                                          color: Constants.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Card(
                                      color: Constants.tile,
                                      child: Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Text(
                                          pastLaunches.length.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Oxanium',
                                              fontSize: 17,
                                              color: Constants.grey,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Upcoming',
                                      style: TextStyle(
                                          fontFamily: 'Oxanium',
                                          fontSize: 17,
                                          color: Constants.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Card(
                                      color: Constants.tile,
                                      child: Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Text(
                                          upcomingLaunches.length.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Oxanium',
                                              fontSize: 17,
                                              color: Constants.grey,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ])
                            ],
                            views: [
                              pastLaunches.length != 0
                                  ? Container(
                                      height: 120,
                                      child: ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        scrollDirection: Axis.vertical,
                                        itemCount: pastLaunches.length,
                                        itemBuilder: (context, index) {
                                          return PreviousLaunchTile(
                                            launch: pastLaunches[
                                                pastLaunches.length -
                                                    index -
                                                    1],
                                            upcoming: false,
                                          );
                                        },
                                      ))
                                  : Container(
                                      height: 120,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "images/rocket.png",
                                              width: 50,
                                              height: 50,
                                              color: Constants.accent,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(height: 25,),
                                            Text(
                                              'Looks like something went wrong. Try restarting the app.',
                                              style: TextStyle(
                                                  fontFamily: 'Oxanium',
                                                  fontSize: 12,
                                                  color: Constants.grey,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            
                                          ],
                                        ),
                                      ),
                                    ),
                              upcomingLaunches.length != null ? Container(
                                  height: 110,
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    scrollDirection: Axis.vertical,
                                    itemCount: upcomingLaunches.length - 1,
                                    itemBuilder: (context, index) {
                                      return UpcomingLaunchTile(
                                        launch: upcomingLaunches[index + 1],
                                        upcoming: true,
                                      );
                                    },
                                  )) : 
                                  Container(
                                      height: 120,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "images/rocket.png",
                                              width: 50,
                                              height: 50,
                                              color: Constants.accent,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(height: 25,),
                                            Text(
                                              'There are no upcoming launches scheduled, come back later.',
                                              style: TextStyle(
                                                  fontFamily: 'Oxanium',
                                                  fontSize: 12,
                                                  color: Constants.grey,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                            onChange: (index) => print(index),
                          ),
                        ),
                      ),
                    ]),
                  )
                : Stack(children: [
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "SpaceX ",
                              style: TextStyle(
                                  fontFamily: 'Spacex',
                                  fontSize: 25,
                                  color: Constants.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            Image.asset(
                              "images/rocket.png",
                              width: 20,
                              height: 20,
                              color: Constants.accent,
                              fit: BoxFit.contain,
                            ),
                            Text(
                              " Launches",
                              style: TextStyle(
                                  fontFamily: 'Spacex',
                                  fontSize: 25,
                                  color: Constants.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ]),
                    ),
                    Center(
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
                          "Loading launches",
                          style: TextStyle(
                              fontFamily: 'Spacex',
                              fontSize: 15,
                              color: Constants.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                  ]),
          ]),
    );
  }
}

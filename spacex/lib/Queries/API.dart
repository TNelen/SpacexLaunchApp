import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "https://api.spacexdata.com/v4";

enum CONNECTIONSTATE {
    LOADING, TIMEOUT, SUCCESS
  }

class API {

  


  static Future getUpcomingLaunches() {
    var url = baseUrl + "/launches/upcoming";
    return http.get(Uri.parse(url));
  }

  static Future getPastLaunches() {
    var url = baseUrl + "/launches/past";
    return http.get(Uri.parse(url));
  }

  static Future getLaunch(String id) {
    var url = baseUrl + "/launches/" + id;
    return http.get(Uri.parse(url));
  }

  static Future getNextLaunch() {
    var url = baseUrl + "/launches/next";
    return http.get(Uri.parse(url));
  }

  static Future getRocket(String id) {
    var url = baseUrl + "/rockets/" + id;
    return http.get(Uri.parse(url));
  }

  static Future getLaunchpad(String id) {
    var url = baseUrl + "/launchpads/" + id;
    return http.get(Uri.parse(url));
  }

  static Future getPayload(String id) {
    var url = baseUrl + "/payloads/" + id;
    return http.get(Uri.parse(url));
  }
}

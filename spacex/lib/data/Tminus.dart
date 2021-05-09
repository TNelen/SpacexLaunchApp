import 'package:duration/duration.dart';

class Tminus {
  Tminus();

  String calculateTminus(String liftoff) {
    DateTime launchtime = DateTime.parse(liftoff);
    DateTime now = DateTime.now().toUtc();

    print(launchtime);
    print(launchtime.toUtc());

    if (launchtime.isAfter(now)) {
      Duration difference = launchtime.difference(now);
      return prettyDuration(difference, abbreviated: true, delimiter: ": ");
    } else {
      return "0";
    }
  }

  String calculateTminusNoSec(String liftoff) {
    DateTime launchtime = DateTime.parse(liftoff).toUtc();
    DateTime now = DateTime.now().toUtc();

    if (launchtime.isAfter(now)) {
      Duration difference = launchtime.difference(now);
      return prettyDuration(difference,
          abbreviated: true, delimiter: ": ", tersity: DurationTersity.minute);
    } else {
      return "0";
    }
  }
}

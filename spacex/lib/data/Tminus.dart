import 'package:duration/duration.dart';

class Tminus {
  Tminus();

  String calculateTminus(String liftoff) {
    DateTime launchtime = DateTime.parse(liftoff).toUtc();
    DateTime now = DateTime.now().toUtc();

    Duration difference = launchtime.difference(now);
    return prettyDuration(difference, abbreviated: true, delimiter: ": ");
  }

  String calculateTminusNoSec(String liftoff) {
    DateTime launchtime = DateTime.parse(liftoff).toUtc();
    DateTime now = DateTime.now().toUtc();

    Duration difference = launchtime.difference(now);
    return prettyDuration(difference,
        abbreviated: true, delimiter: ": ", tersity: DurationTersity.minute);
  }
}

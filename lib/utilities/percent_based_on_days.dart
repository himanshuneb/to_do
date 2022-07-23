//import 'package:intl/intl.dart';

double percentDays(DateTime s, DateTime e) {
  DateTime t = DateTime.now();
  //print(t.difference(s).inDays);
  if (t.difference(s).inDays <= 0) {
    return 0;
  } else {
    double totalBetweenEndAndStart = e.difference(s).inDays.toDouble();
    double daysSinceStart = t.difference(s).inDays.toDouble();
    double percent = daysSinceStart / totalBetweenEndAndStart * 100;
    percent = num.parse(percent.toStringAsFixed(2));
    return percent < 100 ? percent : 100;
  }
}

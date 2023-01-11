import 'package:desktop_app/people/Patient.dart';

class Point {
  final double time;
  final Patient p;
  Point.empty() : this(0, Patient.empty());
  Point(this.time, this.p);
}

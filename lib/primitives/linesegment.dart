import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/point.dart';

RegExp _lineSegmentComponentParser =
    RegExp(r'^\[\s*(?<aval>\([^\)]+\))\s*-\s*(?<bval>\([^\)]+\))\s*\]$');

class LineSegment {
  Point a;
  Point b;

  /// Zero constructor
  LineSegment.zero()
      : a = new Point.zero(),
        b = new Point.zero();

  /// Default constructor
  ///
  /// This constructor clones input values rather than referencing them.
  ///
  /// @param a one point on the line segment
  /// @param b the other point on the line segment
  LineSegment(Point a, Point b)
      : this.a = a.clone(),
        this.b = b.clone();

  /// Performs a deep copy of the line segment
  ///
  /// @return a deep copied line segment
  LineSegment clone() => new LineSegment(a.clone(), b.clone());

  /// toString() implementation
  String toString() => "[$a-$b]";

  /// Attempt to parse the given string into a line segment
  ///
  /// @param str the string to parse
  /// @return the resulting LineSegment or null
  static LineSegment? tryParse(String str) {
    Iterable<RegExpMatch> matches = _lineSegmentComponentParser.allMatches(str);

    RegExpMatch match;
    try {
      match = matches.single;
    } on StateError {
      // State error is generated where there isn't a single match on a regexp
      return null;
    }

    String? aPointString = match.namedGroup('aval');
    String? bPointString = match.namedGroup('bval');
    if (aPointString == null || bPointString == null) return null;

    Point? parsedAValue = Point.tryParse(aPointString.trim());
    Point? parsedBValue = Point.tryParse(bPointString.trim());

    if (parsedAValue == null || parsedBValue == null) return null;

    return new LineSegment(parsedAValue, parsedBValue);
  }

  /// Returns the midpoint of the line segment
  ///
  /// @return the point representing the midpoint
  Point bisect() => new Point(a.x + ((b.x - a.x) / 2), a.y + ((b.y - a.y) / 2));

  /// Returns the angle of the line segment travelling from a to b
  ///
  /// @return the angle of the segment in degrees from points a to b
  double get angle => a.angleTo(b);

  /// Returns the length of the line segment
  Measurement get length => a.distanceTo(b);

  /// Sets the length of the line segment by moving point b along the same angle
  ///
  /// It should be noted that this is a trigonometric floating point function
  /// and therefore will not always produce pretty results. It will be very very
  /// close.
  set length(Measurement value) => b = a.copyByAngle(value, angle);

  /// Rotates this line segment around the given axis by the given degrees.
  ///
  /// This is an in-place operation and does not return a result.
  ///
  /// @param origin the center of rotation
  /// @param angle the number of degrees to rotate the line
  rotate(Point origin, double angle) {
    a = a.rotate(origin, angle);
    b = b.rotate(origin, angle);
  }

  /// Creates a new line segment which bisects this segment orthagonally.
  ///
  /// @param cwLength the distance from the bisection clockwise
  /// @param ccwLength the distance from the bisection counter-clockwise
  /// @return the new bisecting segment
  LineSegment bisectingSegment(Measurement cwLength, ccwLength) {
    var midpoint = bisect();
    var angle = this.angle + 90.0;

    return new LineSegment(midpoint.copyByAngle(cwLength, angle),
        midpoint.copyByAngle(ccwLength, angle + 180.0));
  }

  /// Calculates the point where two segment intersect
  ///
  /// @param other The segment to intersect with
  /// @return the point of intersection or null
  Point? findSegmentIntersection(LineSegment other) {
    var s1 = b - a;
    var s2 = other.b - other.a;

    var s =
        (-s1.y.multiplyBy(a.x - other.a.x) + s1.x.multiplyBy(a.y - other.a.y))
                .points /
            (-s2.x.multiplyBy(s1.y) + s1.x.multiplyBy(s2.y)).points;

    var t =
        (s2.x.multiplyBy(a.y - other.a.y) - s2.y.multiplyBy(a.x - other.a.x))
                .points /
            (-s2.x.multiplyBy(s1.y) + s1.x.multiplyBy(s2.y)).points;

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
      return new Point(a.x + (s1.x * t), a.y + (s1.y * t));

    return null;
  }

  /// Finds a point along the path when traveling as a ray from point a through b
  ///
  /// This function is unbounded and simply returns a point along the ray a -> b
  /// with a distance from a relative to the length of the segment.
  ///
  /// @param t a factor to multiple the segment's length by
  /// @return the requested point along the ray.
  Point along(double t) => a.copyByAngle(length * t, angle);

  /// Creates a copy of the segment extending point b by the given distance
  ///
  /// @param byDistance the distance to extend by
  /// @return the new line segment
  LineSegment extendedBy(Measurement byDistance) =>
      new LineSegment(a, b.copyByAngle(byDistance, angle));

  /// Creates a copy of the segment with the new length as given starting from a
  ///
  /// @param newLength the specific length
  /// @return the new line segment
  LineSegment withLength(Measurement newLength) =>
      new LineSegment(a, a.copyByAngle(newLength, angle));

  /// Calculates the slope of the line segment
  double get slope => slopeOf(a, b);

  /// Calculates the slope of the line segment formed by two points
  ///
  /// This is a helper function provided as a shortcut
  ///
  /// @param a the starting point
  /// @param b the ending point
  /// @return the slope of the line produced by the points.
  static double slopeOf(Point a, Point b) => (b.y - a.y).mm / (b.x - a.x).mm;

  /// Rotates this line segment clockwise around it's a point a until it rests
  /// on the given line.
  ///
  /// This function is constrained to only returning a value if the point
  /// does actually land on the other line segment, not the entire line.
  ///
  /// Also if this line intersects the other line to start with, a value
  /// will not be returned.
  ///
  /// @param other The line to rest against
  /// @return either the new line segment or null if this function fails to meet
  ///   its constraints.
  LineSegment? rotateCWUntilIntersectionWith(LineSegment other) {
    var newBPoint = b.rotateAroundPointUntilIntersectCW(a, other);

    if (newBPoint == null) return null;

    return new LineSegment(a.clone(), newBPoint);
  }

  /// Rotates this line segment counter-clockwise around it's a point a until it
  /// rests on the given line.
  ///
  /// This function is constrained to only returning a value if the point
  /// does actually land on the other line segment, not the entire line.
  ///
  /// Also if this line intersects the other line to start with, a value
  /// will not be returned.
  ///
  /// @param other The line to rest against
  /// @return either the new line segment or null if this function fails to meet
  ///   its constraints.
  LineSegment? rotateCCWUntilIntersectionWith(LineSegment other) {
    var newBPoint = b.rotateAroundPointUntilIntersectCCW(a, other);

    if (newBPoint == null) return null;

    return new LineSegment(a.clone(), newBPoint);
  }

  /// Calculates the point on this segment resting the closest to the specified
  ///   point.
  ///
  /// TODO: review and document algorithm
  ///
  /// @param p the point to find the shortest path to.
  /// @return the point nearest on this segment to the given point.
  Point nearestPoint(Point p) {
    var pA = a.cloneAsUnits(MeasurementUnit.millimeters);
    var pB = b.cloneAsUnits(MeasurementUnit.millimeters);
    var pP = p.cloneAsUnits(MeasurementUnit.millimeters);

    var ap = pP - pA;
    var ab = pB - pA;

    var magnitude = ab.squaredLength().mm;
    var apabDot = ap.dot(ab).mm;
    var distance = apabDot / magnitude;

    if (distance < 0) return a;
    if (distance > 1) return b;

    return pA + ab.scaled(distance);
  }
}

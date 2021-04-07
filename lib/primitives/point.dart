import 'dart:math' as math;

import 'measurement.dart';

RegExp _pointComponentParser =
    RegExp(r'^\(\s*(?<xval>[^,]+)\s*,\s*(?<yval>[^)]+)\)$');

/// Represents a point based on measurements
class Point {
  /// The X coordinate
  Measurement x;

  /// The Y coordinate
  Measurement y;

  /// Constructor
  ///
  /// @param the X coordinate
  /// @param the Y coordinate
  Point(this.x, this.y);

  /// Zero constructor
  Point.zero()
      : x = new Measurement.zero(),
        y = new Measurement.zero();

  /// To string override
  ///
  /// @return Returns a string in format ([x], [y]) as measurements
  String toString() => '($x, $y)';

  /// Try to parse a string into a point value
  ///
  /// @param str the string to parse
  /// @return the parsed Point or null
  static Point? tryParse(String str) {
    Iterable<RegExpMatch> matches = _pointComponentParser.allMatches(str);

    RegExpMatch match;
    try {
      match = matches.single;
    } on StateError {
      // State error is generated where there isn't a single match on a regexp
      return null;
    }

    String? xMeasurementString = match.namedGroup('xval');
    String? yMeasurementString = match.namedGroup('yval');
    if (xMeasurementString == null || yMeasurementString == null) return null;

    Measurement? parsedXValue = Measurement.tryParse(xMeasurementString.trim());
    Measurement? parsedYValue = Measurement.tryParse(yMeasurementString.trim());

    if (parsedXValue == null || parsedYValue == null) return null;

    return new Point(parsedXValue, parsedYValue);
  }

  /// Deep copy the point
  ///
  /// @return The new point
  Point clone() => new Point(x.clone(), y.clone());

  /// Create a new point offset by the given offsets
  ///
  /// @param offsetX the X offset from this point
  /// @param offsetY the Y offset from this point
  /// @return the new point
  Point copyBy(Measurement offsetX, Measurement offsetY) =>
      new Point(x + offsetX, y + offsetY);

  /// Translate this point by the given offsets
  ///
  /// @param offsetX the X offset from the original point
  /// @param offsetY the Y offset from the original point
  translate(Measurement offsetX, Measurement offsetY) {
    x += offsetX;
    y += offsetY;
  }

  /// Creates a new point offset by a distance and direction
  ///
  /// @param distance the distance from the original point
  /// @param angle the clockwise angle of direction in degrees
  /// @return the new point
  Point copyByAngle(Measurement distance, double angle) {
    return new Point(x - distance * math.cos(angle * math.pi / 180.0),
        y - distance * math.sin(angle * math.pi / 180.0));
  }

  /// Returns the distance to the given point
  ///
  /// @param destination the point to measure the distance to
  /// @return the measurement to the given point from this point
  Measurement distanceTo(Point destination) =>
      ((destination.y - y).pow(2) + (destination.x - x).pow(2)).sqrt;

  /// Angle to another point
  ///
  /// @param destination the point to measure the angle to
  /// @return the angle to the given point in degrees
  double angleTo(Point destination) {
    var w = destination.x - x;
    var h = destination.y - y;

    var angleRadians = math.atan2(h.points, w.points);

    var result = 180 + (angleRadians / (math.pi / 180));

    return result % 360.0;
  }

  /// Rotate this point around an origin
  ///
  /// @param origin the point to rotate
  /// @param angle the degrees clockwise to rotate the point
  /// @return a copy of the point rotated
  Point rotate(Point origin, double angle) {
    var distance = distanceTo(origin);
    var oldAngle = origin.angleTo(this);

    return origin.copyByAngle(distance, oldAngle + angle);
  }

  /// Scales this point relative to the origin by the given factor
  ///
  /// @param factor the factor to scale from the origin by
  /// @return the calculated result
  Point scaled(double factor) => new Point(x * factor, y * factor);

  /// Addition operator
  ///
  /// @param other the other addend
  /// @result the sum of the parts
  Point operator +(Point other) => new Point(x + other.x, y + other.y);

  /// Subtraction operator
  ///
  /// @param other the subtrahend
  /// @result the sum of the parts
  Point operator -(Point other) => new Point(x - other.x, y - other.y);

  /// Multiplication (matrix form)
  ///
  /// @param other the other term
  /// @result the sum of the parts
  Point multiplyBy(Point other) =>
      new Point(x.multiplyBy(other.x), y.multiplyBy(other.y));

  /// Multiplication operator (scalar form)
  ///
  /// @param other the other term
  /// @result the product of the parts
  Point operator *(double other) => scaled(other);

  /// Equal operator
  bool operator ==(Object other) =>
      (other is Point) && x == other.x && y == other.y;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  /// Dot product
  ///
  /// @param other term in dot product
  /// @result the dot product of the two terms
  Measurement dot(Point other) {
    var product = this.multiplyBy(other);
    return product.x + product.y;
  }

  /// Calculates the radicand of the pythagorean formula for two points
  ///
  /// We assume the origin is the right angle corner of the triangle.
  /// This point is one of the points adjacent to the hypoteneus.
  /// The other point provided is the other adjacent point to the hypoteneus.
  ///
  /// This is a convenient helper function that is used extensively when
  /// finding roots in 4rd order polynomials which is quite useful for functions
  /// related to 4th order Bezier curves.
  ///
  /// @param other the other last point of the triangle.
  /// @return the radicand of the square root of the pythagorean theorem.
  Measurement distanceToSquared(Point other) =>
      (other.x - x).pow(2) + (other.y - y).pow(2);

  /// Calculates the counterclockwise angle of two other points relative to this point
  ///
  /// angle = a -> this -> b
  ///
  /// The angle is normalized between -180 and +180
  ///
  /// @param a first point
  /// @param b last point
  /// @return the counterclockwise angle in degrees between a and b
  ///   relative to this
  double angleBetween(Point a, Point b) {
    double angle = angleTo(b) - angleTo(a);

    return angle > 180
        ? -(360 - angle)
        : angle < -180
            ? -(-360 - angle)
            : angle;
  }
}

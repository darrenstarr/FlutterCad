import 'dart:math' as math;
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:vector_math/vector_math.dart';
import 'package:fluttercad/primitives/linesegment.dart';

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

  /// Deep copy the point an normalize to the specified units
  ///
  /// @param destinationUnits the desired unit format
  /// @return the new point
  Point cloneAsUnits(MeasurementUnit destinationUnits) => new Point(
      x.cloneConverted(destinationUnits), y.cloneConverted(destinationUnits));

  /// Transpose and create a deep copy
  ///
  /// @return this point with X and Y reversed
  Point cloneTransposed() => new Point(y.clone(), x.clone());

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

  /// Calculates the squared length of this point from the origin
  ///
  /// This is a helper function that eliminates an unneeded sqrt call
  /// when simply comparing lengths of segments.
  Measurement squaredLength() => x.pow(2) + y.pow(2);

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

  /// Rotates this point clockwise around another point until it
  /// rests on the given line in the expressed direction.
  ///
  /// @see [rotateAroundPointUntilIntersect] for details
  ///
  /// This function sets the constraints that the point must rest on the segment
  /// and that the segments can't intersect at the start
  ///
  /// @param axis the axis to rotate upon
  /// @param target The line to rest against
  ///
  /// @return either the touching point or null if this function fails to meet
  ///   its constraints.
  Point? rotateAroundPointUntilIntersectCW(Point axis, LineSegment target) {
    return rotateAroundPointUntilIntersect(axis, target, true, true, true);
  }

  /// Rotates this point counter-clockwise around another point until it
  /// rests on the given line in the expressed direction.
  ///
  /// @see [rotateAroundPointUntilIntersect] for details
  ///
  /// This function sets the constraints that the point must rest on the segment
  /// and that the segments can't intersect at the start
  ///
  /// @param axis the axis to rotate upon
  /// @param target The line to rest against
  ///
  /// @return either the touching point or null if this function fails to meet
  ///   its constraints.
  Point? rotateAroundPointUntilIntersectCCW(Point axis, LineSegment target) {
    return rotateAroundPointUntilIntersect(axis, target, false, true, true);
  }

  /// Rotates this point around another point until it
  /// rests on the given line in the expressed direction.
  ///
  /// This function is constrained to only returning a value if the point
  /// does actually land on the other line segment, not the entire line.
  ///
  /// Also if this line intersects the other line to start with, a value
  /// will not be returned.
  ///
  /// @param axis the axis to rotate upon
  /// @param target The line to rest against
  /// @param clockwise true for clockwise, false for counter clockwise
  /// @param onSegment enforce that the point is on the segment, not the line
  /// @param failOnIntersect fails if the segment produced by this point and
  ///   the axis intersects the target.
  ///
  /// @return either the touching point or null if this function fails to meet
  ///   its constraints.
  Point? rotateAroundPointUntilIntersect(Point axis, LineSegment target,
      bool clockwise, bool onSegment, bool failOnIntersect) {
    var zero = new Measurement(0.0, MeasurementUnit.millimeters);

    // Create copies of the input points with their units normalized
    // to millimeters so that multiplication and division will always
    // return compatible products.
    var A = axis.cloneAsUnits(MeasurementUnit.millimeters);
    var B = this.cloneAsUnits(MeasurementUnit.millimeters);
    var C = target.a.cloneAsUnits(MeasurementUnit.millimeters);
    var D = target.b.cloneAsUnits(MeasurementUnit.millimeters);

    // Test whether line segment CD is vertical.
    var transpose = C.x == D.x;

    // Create a translated copy of the points so that the new A is on
    // the origin. Optionally transpose all points so that the slope of CD
    // is a valid number.
    var pA = new Point.zero();
    Point pB, pC, pD;
    if (transpose) {
      pB = (B - A).cloneTransposed();
      pC = (C - A).cloneTransposed();
      pD = (D - A).cloneTransposed();
    } else {
      pB = B - A;
      pC = C - A;
      pD = D - A;
    }

    // Find the slope of line CD
    var mCD = LineSegment.slopeOf(pC, pD);

    // Calculate the point (pE) where pE is bisects pCpD and pApE is
    // perpendicular to pCpD
    Point pE;
    if (transpose) {
      pE = new Point(zero, pC.y);
    } else {
      // Find the y-intercept of line pCpD
      var bpCpD = pC.y - (pC.x * mCD);

      // Find the slope of perpendicual intersection of the line pCpD
      var mAE = -(1.0 / mCD);

      var pEx = bpCpD / (mAE - mCD);
      var pEy = pEx * mAE;
      pE = new Point(pEx, pEy);
    }

    // Get the length of pApE which will form the base of an isoscolese triangle
    // where pA is the height and the base is colinear to pCpD
    var lenpApE = pA.distanceTo(pE);

    // Calculate the half length of the base of the formentioned triangle where
    // the two congruent sides are equal in length to AB
    var lenAB = distanceTo(A);
    var lenpEpF = (lenAB.multiplyBy(lenAB) - lenpApE.multiplyBy(lenpApE)).sqrt;

    // Calculate the X delta travelled per unit along CD
    var dmxCD = math.sqrt(mCD * mCD + 1);

    // Calculate cartersian offsets from point pE to the points representing the
    // base of the forementioned triangle.
    var deltaX = lenpEpF / dmxCD;
    var deltaY = deltaX * mCD;

    // One of these two points will be clockwise relative to point pB around pA
    // and the other will be counter clockwise.
    var pF = new Point(pE.x - deltaX, pE.y - deltaY);
    var pG = new Point(pE.x + deltaX, pE.y + deltaY);

    // To identify which direction each point is relative to pA, calculate the
    // cross products of the angles. As the earlier transposal required for a
    // vertical CD reverses the direction of the calculation these values must
    // be calculated with regard to that.
    bool bBAG, bBAF, bFAG;
    if (transpose) {
      bBAF = (pB.y.multiplyBy(pF.x) - pB.x.multiplyBy(pF.y)) <= zero;
      bBAG = (pB.y.multiplyBy(pG.x) - pB.x.multiplyBy(pG.y)) <= zero;
      bFAG = (pF.y.multiplyBy(pG.x) - pF.x.multiplyBy(pG.y)) <= zero;
    } else {
      bBAF = (pB.x.multiplyBy(pF.y) - pB.y.multiplyBy(pF.x)) <= zero;
      bBAG = (pB.x.multiplyBy(pG.y) - pB.y.multiplyBy(pG.x)) <= zero;
      bFAG = (pF.x.multiplyBy(pG.y) - pF.y.multiplyBy(pG.x)) <= zero;
    }

    /// If the caller requests that the function should fail when AB intersects
    /// CD, exit.
    if (failOnIntersect &&
        ((bBAF && !(bBAG || bFAG)) || (!bBAF && bBAG && bFAG))) {
      return null;
    }

    // Identify whether pF is clockwise from pB around pA. This
    // also considers whether pG affects pF's relationship to pB.
    if (((bBAG && bBAF && bFAG) || ((!bBAG) && (bBAF || bFAG))) == clockwise) {
      // Now we identify whether pF is between pC and pD by ensuring that
      // angle pC -> pA -> pF and angle pF -> pA -> pD flow in the same
      // direction
      var bCAF = (pC.x.multiplyBy(pF.y) - pC.y.multiplyBy(pF.x)) > zero;
      var bFAD = (pF.x.multiplyBy(pD.y) - pF.y.multiplyBy(pD.x)) > zero;
      var bFonSegment = bCAF == bFAD;

      if (!onSegment || bFonSegment) {
        if (transpose)
          return pF.cloneTransposed() + A;
        else
          return pF + A;
      }
    } else {
      // We perform the same test for pG as we did for pF above.
      var bCAG = (pC.x.multiplyBy(pG.y) - pC.y.multiplyBy(pG.x)) > zero;
      var bGAD = (pG.x.multiplyBy(pD.y) - pG.y.multiplyBy(pD.x)) > zero;
      var bGonSegment = bCAG == bGAD;

      if (!onSegment || bGonSegment) {
        if (transpose)
          return pG.cloneTransposed() + A;
        else
          return pG + A;
      }
    }

    return null;
  }
}

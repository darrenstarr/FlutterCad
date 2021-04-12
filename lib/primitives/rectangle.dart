import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/point.dart';
import 'package:fluttercad/primitives/size.dart';

import 'measurement.dart';

RegExp _rectangleComponentParser = RegExp(r'^(?<mVals>\(\s*('
    r'?<xval>[^,]+)\s*,\s*('
    r'?<yval>[^)]+),\s*('
    r'?<wval>[^)]+),\s*('
    r'?<hval>[^)]+)\))'
    r'|(?<cVals>\(\s*('
    r'?<lval>[^,]+)\s*,\s*('
    r'?<tval>[^)]+)\)-(\s*\(('
    r'?<rval>[^,]+)\s*,\s*('
    r'?<bval>[^)]+)\)))$');

/// Implements a rectangle
class Rectangle {
  Point position;
  Size size;

  // X get accessor
  Measurement get x => position.x;

  // X set accessor
  set x(Measurement value) => position.x = value;

  // Y get accessor
  Measurement get y => position.y;

  // Y set accessor
  set y(Measurement value) => position.y = value;

  // Width get accessor
  Measurement get width => size.width;

  // Width set accessor
  set width(Measurement value) => size.width = value;

  // Height get accessor
  Measurement get height => size.height;

  // Height set accessor
  set height(Measurement value) => size.height = value;

  // x1 get accessor
  Measurement get x1 => position.x;

  // x1 set accessor
  set x1(Measurement value) => position.x = value;

  // y1 get accessor
  Measurement get y1 => position.y;

  // y1 set accessor
  set y1(Measurement value) => position.y = value;

  // x2 get accessor
  Measurement get x2 => position.x + size.width;

  // x2 set accessor
  set x2(Measurement value) => size.width = value - position.x;

  // y2 get accessor
  Measurement get y2 => position.y + size.height;

  // y2 set accessor
  set y2(Measurement value) => size.height = value - position.y;

  // left coordinate get accessor
  Measurement get left => Measurement.min(x1, x2);

  // left coordinate set accessor
  set left(Measurement value) => x1 = value;

  // top coordinate get accessor
  Measurement get top => Measurement.min(y1, y2);

  // top coordinate set accessor
  set top(Measurement value) => y1 = value;

  // right coordinate get accessor
  Measurement get right => Measurement.max(x1, x2);

  // right coordinate set accessor
  set right(Measurement value) => x2 = value;

  // bottom coordinate get accessor
  Measurement get bottom => Measurement.max(y1, y2);

  // bottom coordinate set accessor
  set bottom(Measurement value) => y2 = value;

  // Top-left coordinate get accessor
  Point get topLeft => position;

  // Top-left coordinate set accessor
  set topLeft(Point value) => position = value;

  // Bottom-right coordinate get accessor
  Point get bottomRight => Point(right, bottom);

  // Bottom-right coordinate set accessor
  set bottomRight(Point value) {
    right = value.x;
    bottom = value.y;
  }

  /// Default constructor
  ///
  /// @param position The position of the rectangle
  /// @param size The size of the rectangle
  Rectangle(this.position, this.size);

  /// Constructor based on individual measurements
  ///
  /// @param x left-side of rectangle
  /// @param y top side of rectangle
  /// @param width width of the rectangle
  /// @param height height of the rectangle
  Rectangle.metrics(
      Measurement x, Measurement y, Measurement width, Measurement height)
      : position = Point(x, y),
        size = Size(width, height);

  /// Constructor based on corner coordinates
  ///
  /// @param topLeft the top left corner of the rectangle
  /// @param bottomRight the bottom right corner of the rectangle
  Rectangle.coordinates(Point topLeft, Point bottomRight)
      : position = topLeft,
        size = Size.fromPoint(bottomRight - topLeft);

  /// Constructor based on edge coordinates
  ///
  /// @param left Coordinate of left edge
  /// @param top Coordinate of top edge
  /// @param right Coordinate of right edge
  /// @param bottom Coordinate of bottom edge
  Rectangle.edges(
      Measurement left, Measurement top, Measurement right, Measurement bottom)
      : position = Point(left, top),
        size = Size(right - left, bottom - top);

  /// Deep copy
  ///
  /// @return a deep copy of the rectangle object
  Rectangle clone() => Rectangle(position.clone(), size.clone());

  /// Deep copy with unit normalization
  ///
  /// @param destinationUnits The measurement units to normalize to
  /// @return a normalized deep copy
  Rectangle cloneAsUnits(MeasurementUnit destinationUnits) => Rectangle(
      position.cloneAsUnits(destinationUnits),
      size.cloneAsUnits(destinationUnits));

  /// toString implementation
  ///
  /// @return The string formatted as ([x], [y], [width], [height])
  @override
  String toString() => '($x, $y, $width, $height)';

  /// Try to parse the input string into a rectangle object
  ///
  /// Valid formats include
  ///  - "(x,y,width,height)"
  ///  - "(left, top)-(right, bottom)"
  /// @param str The string to parse
  /// @return the new rectangle object or null if parsing fails
  static Rectangle? tryParse(String str) {
    var matches = _rectangleComponentParser.allMatches(str);

    RegExpMatch match;
    try {
      match = matches.single;
    } on StateError {
      // State error is generated where there isn't a single match on a regexp
      return null;
    }

    if (match.namedGroup('mVals') != null) {
      var xMeasurementString = match.namedGroup('xval');
      var yMeasurementString = match.namedGroup('yval');
      var widthMeasurementString = match.namedGroup('wval');
      var heightMeasurementString = match.namedGroup('hval');

      if (xMeasurementString == null ||
          yMeasurementString == null ||
          widthMeasurementString == null ||
          heightMeasurementString == null) return null;

      var parsedXValue = Measurement.tryParse(xMeasurementString.trim());
      var parsedYValue = Measurement.tryParse(yMeasurementString.trim());
      var parsedWidthValue =
          Measurement.tryParse(widthMeasurementString.trim());
      var parsedHeightValue =
          Measurement.tryParse(heightMeasurementString.trim());

      if (parsedXValue == null ||
          parsedYValue == null ||
          parsedWidthValue == null ||
          parsedHeightValue == null) return null;

      return Rectangle.metrics(
          parsedXValue, parsedYValue, parsedWidthValue, parsedHeightValue);
    }

    if (match.namedGroup('cVals') != null) {
      var leftMeasurementString = match.namedGroup('lval');
      var topMeasurementString = match.namedGroup('tval');
      var rightMeasurementString = match.namedGroup('rval');
      var bottomMeasurementString = match.namedGroup('bval');

      if (leftMeasurementString == null ||
          topMeasurementString == null ||
          rightMeasurementString == null ||
          bottomMeasurementString == null) return null;

      var parsedLeftValue = Measurement.tryParse(leftMeasurementString.trim());
      var parsedTopValue = Measurement.tryParse(topMeasurementString.trim());
      var parsedRightValue =
          Measurement.tryParse(rightMeasurementString.trim());
      var parsedBottomValue =
          Measurement.tryParse(bottomMeasurementString.trim());

      if (parsedLeftValue == null ||
          parsedTopValue == null ||
          parsedRightValue == null ||
          parsedBottomValue == null) return null;

      return Rectangle(
          Point(parsedLeftValue, parsedTopValue),
          Size(parsedRightValue - parsedLeftValue,
              parsedBottomValue - parsedTopValue));
    }
    return null;
  }

  /// Normalizes the rectangle so that [width] and [height] are positive.
  ///
  /// While it could make sense that all accessors and setters could perform
  /// this as a matter of course, there are times where mathematically, it is
  /// profitable to permit negative width or height values. Therefore, this
  /// function is provided to make this operation explicit.
  void normalize() {
    if (width.isNegative) {
      x += width;
      width = -width;
    }

    if (height.isNegative) {
      y += height;
      height = -height;
    }
  }

  /// Returns a clone which is normalized so that [width] and [height] are positive.
  ///
  /// @return The normalized and deepcopied rectangle.
  Rectangle cloneNormalized() {
    var result = clone();
    result.normalize();

    return result;
  }

  /// Combines the bounds of this rectangle with another
  ///
  /// @param other The rectangle to join this rectangle with
  void Join(Rectangle other) {
    normalize();
    x1 = Measurement.min(x1, other.left);
    y1 = Measurement.min(y1, other.top);
    x2 = Measurement.max(x2, other.right);
    y2 = Measurement.max(y2, other.bottom);
  }

  /// Creates a deep copy of this rectangle and another with their bounds
  ///   combined
  ///
  /// @param other The rectangle to combine this rectangle with
  /// @return the cloned rectangle.
  Rectangle cloneCombined(Rectangle other) => Rectangle.edges(
      Measurement.min(left, other.left).clone(),
      Measurement.min(top, other.top).clone(),
      Measurement.max(right, other.right).clone(),
      Measurement.max(bottom, other.bottom).clone());

  /// Subtracts a size or a point from the rectangle.
  ///
  /// When subtracting a size, the size of this rectangle is altered by the
  /// provided size. Otherwise when given a point, the position of the rectangle
  /// is moved by the given point.
  ///
  /// @param other The point or size to subtract from this rectangle.
  /// @return a new rectangle with the appropriate adjustments
  Rectangle operator -(Object other) {
    if (other is Size) {
      return Rectangle.metrics(
          left, top, width - other.width, height - other.height);
    }

    if (other is Point) {
      return Rectangle.metrics(left - other.x, top - other.y, right, bottom);
    }

    throw ArgumentError(
        'Only Size and Point are accepted types for this operator');
  }

  /// Adds a size or a point from the rectangle.
  ///
  /// When adding a size, the size of this rectangle is altered by the
  /// provided size. Otherwise when given a point, the position of the rectangle
  /// is moved by the given point.
  ///
  /// @param other The point or size to add to this rectangle.
  /// @return a new rectangle with the appropriate adjustments
  Rectangle operator +(Object other) {
    if (other is Size) {
      return Rectangle.metrics(
          left, top, width + other.width, height + other.height);
    }

    if (other is Point) {
      return Rectangle.metrics(left + other.x, top + other.y, right, bottom);
    }

    throw ArgumentError(
        'Only Size and Point are accepted types for this operator');
  }
}

import 'package:fluttercad/primitives/point.dart';

import 'measurement.dart';
import 'measurement_unit.dart';

RegExp _sizeComponentParser =
    RegExp(r'^\(\s*(?<wval>[^,]+)\s*,\s*(?<hval>[^)]+)\)$');

/// Class to implement the geometric representation of size
class Size {
  Measurement width;
  Measurement height;

  /// Default constructor
  Size(this.width, this.height);

  /// Zero constructor
  Size.zero()
      : width = Measurement.zero(),
        height = Measurement.zero();

  /// Deep copy
  ///
  /// @return a deep copy of this value
  Size clone() => Size(width.clone(), height.clone());

  /// toString override
  ///
  /// @return Returns a string in format ([width], [height]) as measurements
  @override
  String toString() => '($width, $height)';

  /// Try to parse a string into a point value
  ///
  /// @param str the string to parse
  /// @return the parsed Point or null
  static Size? tryParse(String str) {
    var matches = _sizeComponentParser.allMatches(str);

    RegExpMatch match;
    try {
      match = matches.single;
    } on StateError {
      // State error is generated where there isn't a single match on a regexp
      return null;
    }

    var widthMeasurementString = match.namedGroup('wval');
    var heightMeasurementString = match.namedGroup('hval');
    if (widthMeasurementString == null || heightMeasurementString == null) {
      return null;
    }

    var parsedWidthValue = Measurement.tryParse(widthMeasurementString.trim());
    var parsedHeightValue =
        Measurement.tryParse(heightMeasurementString.trim());

    if (parsedWidthValue == null || parsedHeightValue == null) return null;

    return Size(parsedWidthValue, parsedHeightValue);
  }

  /// Deep copy with units normalization
  ///
  /// @param destinationUnits the desired output units format
  /// @return the cloned value
  Size cloneAsUnits(MeasurementUnit destinationUnits) => Size(
      width.cloneConverted(destinationUnits),
      height.cloneConverted(destinationUnits));

  /// Alter the size of the... size by the given amounts
  ///
  /// @param growByX the amount to change the width
  /// @param growByY the amount to change the height
  void grow(Measurement growByX, Measurement growByY) {
    width += growByX;
    height += growByY;
  }

  /// Switch the values for width and height
  void transpose() {
    var temp = width;
    width = height;
    height = temp;
  }

  /// Converts a point to a size object
  ///
  /// Conversion happens by converting x to width and y to height
  ///
  /// @param other The point to convert
  /// @return the new size object
  static Size fromPoint(Point other) => Size(other.x, other.y);
}

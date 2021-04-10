import 'measurement.dart';
import 'measurement_unit.dart';

RegExp _sizeComponentParser =
    RegExp(r'^\(\s*(?<xval>[^,]+)\s*,\s*(?<yval>[^)]+)\)$');

/// Class to implement the geometric representation of size
class Size {
  Measurement width;
  Measurement height;

  /// Default constructor
  Size(this.width, this.height);

  /// Zero constructor
  Size.zero()
      : width = new Measurement.zero(),
        height = new Measurement.zero();

  /// Deep copy
  ///
  /// @return a deep copy of this value
  Size clone() => new Size(width.clone(), height.clone());

  /// toString override
  ///
  /// @return Returns a string in format ([width], [height]) as measurements
  String toString() => "($width, $height)";

  /// Try to parse a string into a point value
  ///
  /// @param str the string to parse
  /// @return the parsed Point or null
  static Size? tryParse(String str) {
    Iterable<RegExpMatch> matches = _sizeComponentParser.allMatches(str);

    RegExpMatch match;
    try {
      match = matches.single;
    } on StateError {
      // State error is generated where there isn't a single match on a regexp
      return null;
    }

    String? widthMeasurementString = match.namedGroup('xval');
    String? heightMeasurementString = match.namedGroup('yval');
    if (widthMeasurementString == null || heightMeasurementString == null)
      return null;

    Measurement? parsedWidthValue =
        Measurement.tryParse(widthMeasurementString.trim());
    Measurement? parsedHeightValue =
        Measurement.tryParse(heightMeasurementString.trim());

    if (parsedWidthValue == null || parsedHeightValue == null) return null;

    return new Size(parsedWidthValue, parsedHeightValue);
  }

  /// Deep copy with units normalization
  ///
  /// @param destinationUnits the desired output units format
  /// @return the cloned value
  Size cloneAsUnits(MeasurementUnit destinationUnits) => new Size(
      width.cloneConverted(destinationUnits),
      height.cloneConverted(destinationUnits));

  /// Alter the size of the... size by the given amounts
  ///
  /// @param growByX the amount to change the width
  /// @param growByY the amount to change the height
  grow(Measurement growByX, Measurement growByY) {
    width += growByX;
    height += growByY;
  }

  /// Switch the values for width and height
  transpose() {
    var temp = width;
    width = height;
    height = temp;
  }
}

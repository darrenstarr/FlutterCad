enum MeasurementUnit { centimeters, millimeters, inches, points }

/// Converts measurement units to a 2 letter abbreviation
///
/// @param units the value to convert
/// @return the two letter string cm|mm|in|pt
String measurementUnitToAbbreviation(MeasurementUnit units) {
  switch (units) {
    case MeasurementUnit.centimeters:
      return 'cm';
    case MeasurementUnit.millimeters:
      return 'mm';
    case MeasurementUnit.inches:
      return 'in';
    case MeasurementUnit.points:
      return 'pt';
  }
}

RegExp _measurementUnitParser = RegExp(
    r'^\s*((?<cm>cm\.?|[Cc]entimeter(s)?)|(?<mm>(?:mm\.?|[Mm]illimeter(?:s)?))|(?<in>(?:in\.?|[Ii]nch(?:e)?(?:s)?))|(?<pt>(?:pt\.?|[Pp]oint(?:s)?)))$');

/// Converts a string to measurement unit
///
/// @param unitString value to convert
/// @return the measurement unit if successfully parsed
MeasurementUnit? tryParseMeasurementUnit(String unitString) {
  var matches = _measurementUnitParser.allMatches(unitString);

  try {
    var match = matches.single;

    if (match.namedGroup('cm') != null) {
      return MeasurementUnit.centimeters;
    } else if (match.namedGroup('mm') != null) {
      return MeasurementUnit.millimeters;
    } else if (match.namedGroup('in') != null) {
      return MeasurementUnit.inches;
    } else if (match.namedGroup('pt') != null) {
      return MeasurementUnit.points;
    } else {
      return null;
    }
  } on StateError {
    // State error is generated where there isn't a single match on a regexp
    return null;
  }
}

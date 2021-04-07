import 'dart:math' as math;

import 'package:fluttercad/primitives/measurement_unit.dart';

// This is a monster regexp for handling parsing of measurements
// in multiple forms. It should be in sync with
// https://regex101.com/r/1VBJBK/1
RegExp _measurementComponentParser = RegExp(r'\s*' +
    r'(?:((?<decVal>-?\d+(?:\.\d+)?)|' +
    r'(?:(?<ratSign>-)?' +
    r'(?<wholeVal>\d+\s+)?' +
    r'(?<fracVal>(?<numer>\d+)\/(?<denom>\d+))))\s*' +
    r'(?<unit>' +
    r'(?:cm\.?|[Cc]entimeter(s)?)|' +
    r'(?:(?:mm\.?|[Mm]illimeter(?:s)?))|' +
    r'(?:(?:in\.?|[Ii]nch(?:e)?(?:s)?))|' +
    r'(?:(?:pt\.?|[Pp]oint(?:s)?))))$');

/// Provides a class for storing a measurement with units
class Measurement {
  /// The measurement in raw format
  double value;

  /// The units associated with the measurement
  MeasurementUnit units;

  /// Constructor
  ///
  /// @param value The raw value
  /// @param units The units of measurement
  Measurement(this.value, this.units);

  /// Empty constructor
  Measurement.zero()
      : value = 0.0,
        units = MeasurementUnit.points;

  /// The measurement in terms of millimeters
  double get mm => convertTo(MeasurementUnit.millimeters);

  /// Sets the measurement in terms of millimeters
  set mm(double value) => set(value, MeasurementUnit.millimeters);

  /// The measurement in terms of centimeters
  double get cm => convertTo(MeasurementUnit.centimeters);

  /// Sets the measurement in terms of centimeters
  set cm(double value) => set(value, MeasurementUnit.centimeters);

  /// The measurement in terms of inches
  double get inches => convertTo(MeasurementUnit.inches);

  /// Sets the measurement in terms of inches
  set inches(double value) => set(value, MeasurementUnit.inches);

  /// The measurement in terms of points
  double get points => convertTo(MeasurementUnit.points);

  /// Sets the measurement in terms of points
  set points(double value) => set(value, MeasurementUnit.points);

  /// Sets the values of this instance
  ///
  /// @param value The raw value
  /// @param units The units associated with this measurement
  set(double value, MeasurementUnit units) {
    this.value = value;
    this.units = units;
  }

  /// toString() override.
  ///
  /// This version uses the current units, 3 places of precision and fractions
  String toString() {
    return toStringWithPrecisionAs(3, units);
  }

  /// Converts to a string and allows specification of formating options
  ///
  /// @param precision Round to the maximum decimal places
  /// @param units The units to convert this string to
  /// @param fractions Converts to 1/16th fractions for inches
  String toStringWithPrecisionAs(int precision, MeasurementUnit units,
      {bool fractions = true}) {
    var value = convertTo(units);

    if (fractions && units == MeasurementUnit.inches) {
      var wholeNumber = value.truncate();
      double fractionalComponent =
          ((value - wholeNumber) * 16.0).roundToDouble() / 16.0;

      if (fractionalComponent == 0.000)
        return "$wholeNumber in";
      else if (fractionalComponent == 0.500)
        return "$wholeNumber 1/2 in";
      else if (fractionalComponent % (1 / 4) == 0) {
        var fraction = (fractionalComponent * 4.0).truncate().abs();
        return "$wholeNumber $fraction/4 in";
      } else if (fractionalComponent % (1 / 8) == 0) {
        var fraction = (fractionalComponent * 8.0).truncate().abs();
        return "$wholeNumber $fraction/8 in";
      } else {
        var fraction = (fractionalComponent * 16.0).truncate().abs();
        return "$wholeNumber $fraction/16 in";
      }
    }

    var factor = math.pow(10.0, precision);
    var roundedValue = (value * factor).roundToDouble() / factor;
    var unitString = measurementUnitToAbbreviation(units);

    return "$roundedValue $unitString";
  }

  /// Attempt to parse the given string into the form of a measurement
  ///
  /// Strings can be formatted as a decimal value followed by a unit
  /// or as a whole number and/or rational value followed by a unit.
  ///
  /// @param str The value to parse.
  /// @return the parsed measurement or null on failure
  static Measurement? tryParse(String str) {
    Iterable<RegExpMatch> matches = _measurementComponentParser.allMatches(str);

    RegExpMatch match;
    try {
      match = matches.single;
    } on StateError {
      // State error is generated where there isn't a single match on a regexp
      return null;
    }

    double decimalValue = 0.0;
    String? decimalGroup = match.namedGroup("decVal");
    if (decimalGroup != null) {
      // Handle decimal values here, they are parsed with the sign
      var parsed = double.tryParse(decimalGroup);
      if (parsed == null) return null;

      decimalValue = parsed;
    } else {
      // Handle the fractional values here
      String? rationalSignGroup = match.namedGroup('ratSign');
      String? wholeNumberGroup = match.namedGroup('wholeVal');
      String? numeratorGroup = match.namedGroup('numer');
      String? denominatorGroup = match.namedGroup('denom');

      // Process the whole number component if it's present
      if (wholeNumberGroup != null) {
        var parsedWholeNumber = double.tryParse(wholeNumberGroup);
        if (parsedWholeNumber == null)
          return null;
        else
          decimalValue = parsedWholeNumber;
      }

      // Process the fractional component if it's present
      if (numeratorGroup != null && denominatorGroup != null) {
        var parsedNumerator = double.tryParse(numeratorGroup);
        var parsedDenominator = double.tryParse(denominatorGroup);

        if (parsedNumerator == null || parsedDenominator == null)
          return null;
        else
          decimalValue += parsedNumerator / parsedDenominator;
      } else if (numeratorGroup != null || denominatorGroup != null) {
        // If either the numerator or denominator is missing, fail
        return null;
      }

      // Apply the negative sign if it's present
      if (rationalSignGroup != null) decimalValue = 0 - decimalValue;
    }

    String? unitGroup = match.namedGroup('unit');
    if (unitGroup == null) return null;

    MeasurementUnit? units = tryParseMeasurementUnit(unitGroup);
    if (units == null) return null;

    return new Measurement(decimalValue, units);
  }

  /// Returns a deep copy of the measurement
  Measurement clone() => new Measurement(value, units);

  /// Implements the addition operator as a mutable function
  Measurement operator +(Measurement other) =>
      new Measurement(this.value + other.convertTo(units), units);

  /// Implements the unary subtraction operator as a mutable function
  Measurement operator -() => new Measurement(-value, units);

  /// Implements the subtraction operator as a mutable function
  ///
  /// This is not the most optimal implementation as it will allocate two results
  /// rather than compounding just one. This is because we combine the unary
  /// negation operator with the addition operator.
  ///
  /// TODO: Consider for optimization once tests are fully verified
  Measurement operator -(Measurement other) => this + (-other);

  /// Implements the multiplication operator as a mutable function against a
  /// double precision factor.
  Measurement operator *(double factor) =>
      new Measurement(value * factor, units);

  /// Implements multiplication as a mutable function against
  /// another measurement as a factor.
  ///
  /// Before calculating the result, the units are converted to match
  Measurement multiplyBy(Measurement other) =>
      new Measurement(value * other.convertTo(units), units);

  /// Implements the division operator as a mutable function against a
  /// double precision divisor.
  Measurement operator /(double divisor) =>
      new Measurement(value / divisor, units);

  /// Implements the less than operator
  bool operator <(Measurement other) => value < other.convertTo(units);

  /// Implements the less than or equal to operator
  bool operator <=(Measurement other) => value <= other.convertTo(units);

  /// Implements the greater than operator
  bool operator >(Measurement other) => value > other.convertTo(units);

  /// Implements the greater than or equal to operator
  bool operator >=(Measurement other) => value >= other.convertTo(units);

  /// Implements the equal to operator
  bool operator ==(Object other) =>
      other is Measurement && (value == other.convertTo(units));

  /// Returns the absolute value of a measurement
  Measurement get abs => new Measurement(value.abs(), units);

  /// Returns the value raised to the given exponent
  Measurement pow(double power) =>
      new Measurement(math.pow(value, power).toDouble(), units);

  /// Returns the square root of the measurement
  Measurement get sqrt => new Measurement(math.sqrt(value), units);

  /// Returns which of two measurements is the minimum
  static Measurement min(Measurement a, Measurement b) => a <= b ? a : b;

  /// Returns which of two measurements is the maximum
  static Measurement max(Measurement a, Measurement b) => a >= b ? a : b;

  /// Property which is true when the measurement is zero in length
  bool get isZero => value == 0.0;

  /// Property which is true when the measurement is "not a number"
  bool get isNaN => value.isNaN;

  /// Property which is true when the value is a negative value
  bool get isNegative => value.isNegative;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  /// Converts this measurement to a desired measurement unit
  ///
  /// Throws an [FallThroughError] if for some reason the conversion isn't
  /// implemented
  ///
  /// @param destinationUnits the desired unit format
  /// @return the converted raw value
  double convertTo(MeasurementUnit destinationUnits) {
    if (destinationUnits == units) return value;

    if (units == MeasurementUnit.centimeters) {
      switch (destinationUnits) {
        case MeasurementUnit.millimeters:
          return value * _millimetersPerCentimeter;
        case MeasurementUnit.points:
          return value / _centimetersPerPoint;
        case MeasurementUnit.inches:
          return value / _centimetersPerInch;
        default:
          break;
      }
    } else if (units == MeasurementUnit.millimeters) {
      switch (destinationUnits) {
        case MeasurementUnit.centimeters:
          return value / _millimetersPerCentimeter;
        case MeasurementUnit.points:
          return value / _millimetersPerPoint;
        case MeasurementUnit.inches:
          return value / _millimetersPerInch;
        default:
          break;
      }
    } else if (units == MeasurementUnit.inches) {
      switch (destinationUnits) {
        case MeasurementUnit.centimeters:
          return value * _centimetersPerInch;
        case MeasurementUnit.millimeters:
          return value * _millimetersPerInch;
        case MeasurementUnit.points:
          return value * _pointsPerInch;
        default:
          break;
      }
    } else {
      switch (destinationUnits) {
        case MeasurementUnit.centimeters:
          return value * _centimetersPerPoint;
        case MeasurementUnit.millimeters:
          return value * _millimetersPerPoint;
        case MeasurementUnit.inches:
          return value / _pointsPerInch;
        default:
          break;
      }
    }

    throw new FallThroughError();
  }

  // Below are constants used for conversion

  static const double _millimetersPerCentimeter = 10.0;
  static const double _millimetersPerInch = 25.4;
  static const double _centimetersPerInch =
      _millimetersPerInch / _millimetersPerCentimeter;
  static const double _pointsPerInch = 72.0;
  static const double _centimetersPerPoint =
      _centimetersPerInch / _pointsPerInch;
  static const double _millimetersPerPoint =
      _millimetersPerInch / _pointsPerInch;
}

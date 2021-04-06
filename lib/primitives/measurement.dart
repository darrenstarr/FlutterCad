import 'dart:math' as math;

import 'package:fluttercad/primitives/measurement_unit.dart';

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
  Measurement({this.value = 0.0, this.units = MeasurementUnit.points});

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

  /// Returns a deep copy of the measurement
  Measurement clone() => new Measurement(value: value, units: units);

  /// Implements the addition operator as a mutable function
  Measurement operator +(Measurement other) => new Measurement(
      value: this.value += other.convertTo(units), units: units);

  /// Implements the unary subtraction operator as a mutable function
  Measurement operator -() => new Measurement(value: -value, units: units);

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
      new Measurement(value: value * factor, units: units);

  /// Implements the division operator as a mutable function against a
  /// double precision divisor.
  Measurement operator /(double divisor) =>
      new Measurement(value: value / divisor, units: units);

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
  Measurement get abs => new Measurement(value: value.abs(), units: units);

  /// Returns the value raised to the given exponent
  Measurement pow(double power) =>
      new Measurement(value: math.pow(value, power), units: units);

  /// Returns the square root of the measurement
  Measurement get sqrt =>
      new Measurement(value: math.sqrt(value), units: units);

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

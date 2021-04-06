import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:test/test.dart';

void main() {
  test('Cloning', () {
    var testValueA =
        new Measurement(value: 25.4, units: MeasurementUnit.millimeters);
    expect(25.4, testValueA.mm);

    var testValueB = testValueA.clone();
    expect(25.4, testValueB.mm);

    testValueA.value = 50;

    expect(50, testValueA.mm);
    expect(25.4, testValueB.mm);
  });

  test('Test millimeter to millimeter conversion', () {
    var testValue =
        new Measurement(value: 25.4, units: MeasurementUnit.millimeters);
    expect(25.4, testValue.mm);
  });

  test('Test centimeter to millimeter conversion', () {
    var testValue =
        new Measurement(value: 2.54, units: MeasurementUnit.centimeters);
    expect(25.4, testValue.mm);
  });

  test('Test points to millimeter conversion', () {
    var testValue = new Measurement(value: 72, units: MeasurementUnit.points);
    expect(25.4, testValue.mm);
  });

  test('Test inches to millimeter conversion', () {
    var testValue = new Measurement(value: 1, units: MeasurementUnit.inches);
    expect(25.4, testValue.mm);
  });

  test('Test millimeter to centimeter conversion', () {
    var testValue =
        new Measurement(value: 25.4, units: MeasurementUnit.millimeters);
    expect(2.54, testValue.cm);
  });

  test('Test centimeter to centimeter conversion', () {
    var testValue =
        new Measurement(value: 2.54, units: MeasurementUnit.centimeters);
    expect(2.54, testValue.cm);
  });

  test('Test points to centimeter conversion', () {
    var testValue = new Measurement(value: 72, units: MeasurementUnit.points);
    expect(2.54, testValue.cm);
  });

  test('Test inches to centimeter conversion', () {
    var testValue = new Measurement(value: 1, units: MeasurementUnit.inches);
    expect(2.54, testValue.cm);
  });

  test('Test millimeter to inches conversion', () {
    var testValue =
        new Measurement(value: 25.4, units: MeasurementUnit.millimeters);
    expect(1, testValue.inches);
  });

  test('Test centimeter to inches conversion', () {
    var testValue =
        new Measurement(value: 2.54, units: MeasurementUnit.centimeters);
    expect(1, testValue.inches);
  });

  test('Test points to inches conversion', () {
    var testValue = new Measurement(value: 72, units: MeasurementUnit.points);
    expect(1, testValue.inches);
  });

  test('Test inches to inches conversion', () {
    var testValue = new Measurement(value: 1, units: MeasurementUnit.inches);
    expect(1, testValue.inches);
  });

  test('Test millimeter to points conversion', () {
    var testValue =
        new Measurement(value: 25.4, units: MeasurementUnit.millimeters);
    expect(72, testValue.points);
  });

  test('Test centimeter to points conversion', () {
    var testValue =
        new Measurement(value: 2.54, units: MeasurementUnit.centimeters);
    expect(72, testValue.points);
  });

  test('Test points to points conversion', () {
    var testValue = new Measurement(value: 72, units: MeasurementUnit.points);
    expect(72, testValue.points);
  });

  test('Test inches to points conversion', () {
    var testValue = new Measurement(value: 1, units: MeasurementUnit.inches);
    expect(72, testValue.points);
  });

  test('Add like units', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var result = testValueA + testValueB;

    expect(testDoubleValueA + testDoubleValueB, result.mm);
  });

  test('Add different units', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(value: testDoubleValueB, units: MeasurementUnit.inches);

    var result = testValueA + testValueB;

    expect(testDoubleValueA + (testDoubleValueB * 25.4), result.mm);
  });

  test('Add different units, with other negative', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(value: testDoubleValueB, units: MeasurementUnit.inches);

    var result = testValueA + testValueB;

    expect(testDoubleValueA + (testDoubleValueB * 25.4), result.mm);
  });

  test('Test unary negation operator', () {
    var testDoubleValueA = 1.5;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var result = -testValueA;

    expect(-testDoubleValueA, result.mm);
  });

  test('Subtract like units', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var result = testValueA - testValueB;

    expect(testDoubleValueA - testDoubleValueB, result.mm);
  });

  test('Subtract different units', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(value: testDoubleValueB, units: MeasurementUnit.inches);

    var result = testValueA - testValueB;

    expect(testDoubleValueA - (testDoubleValueB * 25.4), result.mm);
  });

  test('Add different units, with other negative', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(value: testDoubleValueB, units: MeasurementUnit.inches);

    var result = testValueA - testValueB;

    expect(testDoubleValueA - (testDoubleValueB * 25.4), result.mm);
  });

  test('Multiply against a "double" factor', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var result = testValueA * testDoubleValueB;

    expect(testDoubleValueA * testDoubleValueB, result.mm);
  });

  test('Divide by a "double" divisor', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var result = testValueA / testDoubleValueB;

    expect(testDoubleValueA / testDoubleValueB, result.mm);
  });

  test('Compare like units "less than"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(true, testValueA < testValueB);
    expect(false, testValueB < testValueA);
  });

  test('Compare different units "less than"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(value: testDoubleValueA, units: MeasurementUnit.inches);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(false, testValueA < testValueB);
    expect(true, testValueB < testValueA);
  });

  test('Compare like units "less than or equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var testValueC = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(true, testValueA <= testValueB);
    expect(false, testValueB <= testValueA);
    expect(true, testValueC <= testValueB);
  });

  test('Compare different units "less than or equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var testValueC = new Measurement(
        value: testDoubleValueB / 25.4, units: MeasurementUnit.inches);

    expect(false, testValueA <= testValueB);
    expect(true, testValueB <= testValueA);
    expect(true, testValueC <= testValueB);
  });

  test('Compare like units "greater than"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(false, testValueA > testValueB);
    expect(true, testValueB > testValueA);
  });

  test('Compare different units "greater than"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(value: testDoubleValueA, units: MeasurementUnit.inches);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(true, testValueA > testValueB);
    expect(false, testValueB > testValueA);
  });

  test('Compare like units "greater than or equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var testValueC = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(false, testValueA >= testValueB);
    expect(true, testValueB >= testValueA);
    expect(true, testValueC >= testValueB);
  });

  test('Compare different units "greater than or equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var testValueC = new Measurement(
        value: testDoubleValueB / 25.4, units: MeasurementUnit.inches);

    expect(true, testValueA >= testValueB);
    expect(false, testValueB >= testValueA);
    expect(true, testValueC <= testValueB);
  });

  test('Compare like units "equal" and "not equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.millimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var testValueC = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(false, testValueA == testValueB);
    expect(false, testValueB == testValueA);
    expect(true, testValueC == testValueB);
  });

  test('Compare different units "equal" and "not equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var testValueC = new Measurement(
        value: testDoubleValueB / 25.4, units: MeasurementUnit.inches);

    expect(false, testValueA == testValueB);
    expect(false, testValueB == testValueA);
    expect(true, testValueC == testValueB);
  });

  test('Test absolute values', () {
    var testDoubleValueA = -22.5;
    var testDoubleValueB = -testDoubleValueA;
    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    expect(testValueA.abs.cm, testDoubleValueB);
  });

  test('Test square roots', () {
    var testDoubleValueA = 4.5;
    var testDoubleValueB = testDoubleValueA * testDoubleValueA;
    var testValueA = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.centimeters);

    expect(testValueA.sqrt.cm, testDoubleValueA);
  });

  test('Test exponents', () {
    var testDoubleValueA = -22.5;
    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    expect(testDoubleValueA * testDoubleValueA * testDoubleValueA,
        testValueA.pow(3).cm);
  });

  test('Test minimum measurement', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(testValueB, Measurement.min(testValueA, testValueB));
  });

  test('Test maximum measurement', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(testValueA, Measurement.max(testValueA, testValueB));
  });

  test('Test isZero', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 0.0;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    var testValueC = new Measurement();

    expect(testValueA.isZero, false);
    expect(testValueB.isZero, true);
    expect(testValueC.isZero, true);
  });

  test('Test isNegative', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(testValueA.isNegative, false);
    expect(testValueB.isNegative, true);
  });

  test('Test isNaN', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA = new Measurement(
        value: testDoubleValueA, units: MeasurementUnit.centimeters);

    var testValueB = new Measurement(
        value: testDoubleValueB, units: MeasurementUnit.millimeters);

    expect(testValueA.isNaN, false);
    expect(testValueA.sqrt.isNaN, false);
    expect(testValueB.isNaN, false);
    expect(testValueB.sqrt.isNaN, true);
  });
}

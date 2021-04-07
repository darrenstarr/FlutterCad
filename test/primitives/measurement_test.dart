import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:test/test.dart';

void main() {
  test('Cloning', () {
    var testValueA = new Measurement(25.4, MeasurementUnit.millimeters);
    expect(25.4, testValueA.mm);

    var testValueB = testValueA.clone();
    expect(25.4, testValueB.mm);

    testValueA.value = 50;

    expect(50, testValueA.mm);
    expect(25.4, testValueB.mm);
  });

  test('Millimeter to millimeter conversion', () {
    var testValue = new Measurement(25.4, MeasurementUnit.millimeters);
    expect(25.4, testValue.mm);
  });

  test('Centimeter to millimeter conversion', () {
    var testValue = new Measurement(2.54, MeasurementUnit.centimeters);
    expect(25.4, testValue.mm);
  });

  test('Points to millimeter conversion', () {
    var testValue = new Measurement(72, MeasurementUnit.points);
    expect(25.4, testValue.mm);
  });

  test('Inches to millimeter conversion', () {
    var testValue = new Measurement(1, MeasurementUnit.inches);
    expect(25.4, testValue.mm);
  });

  test('Millimeter to centimeter conversion', () {
    var testValue = new Measurement(25.4, MeasurementUnit.millimeters);
    expect(2.54, testValue.cm);
  });

  test('Centimeter to centimeter conversion', () {
    var testValue = new Measurement(2.54, MeasurementUnit.centimeters);
    expect(2.54, testValue.cm);
  });

  test('Points to centimeter conversion', () {
    var testValue = new Measurement(72, MeasurementUnit.points);
    expect(2.54, testValue.cm);
  });

  test('Inches to centimeter conversion', () {
    var testValue = new Measurement(1, MeasurementUnit.inches);
    expect(2.54, testValue.cm);
  });

  test('Millimeter to inches conversion', () {
    var testValue = new Measurement(25.4, MeasurementUnit.millimeters);
    expect(1, testValue.inches);
  });

  test('Centimeter to inches conversion', () {
    var testValue = new Measurement(2.54, MeasurementUnit.centimeters);
    expect(1, testValue.inches);
  });

  test('Points to inches conversion', () {
    var testValue = new Measurement(72, MeasurementUnit.points);
    expect(1, testValue.inches);
  });

  test('Inches to inches conversion', () {
    var testValue = new Measurement(1, MeasurementUnit.inches);
    expect(1, testValue.inches);
  });

  test('Millimeter to points conversion', () {
    var testValue = new Measurement(25.4, MeasurementUnit.millimeters);
    expect(72, testValue.points);
  });

  test('Centimeter to points conversion', () {
    var testValue = new Measurement(2.54, MeasurementUnit.centimeters);
    expect(72, testValue.points);
  });

  test('Points to points conversion', () {
    var testValue = new Measurement(72, MeasurementUnit.points);
    expect(72, testValue.points);
  });

  test('Inches to points conversion', () {
    var testValue = new Measurement(1, MeasurementUnit.inches);
    expect(72, testValue.points);
  });

  test('Add like units', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var result = testValueA + testValueB;

    expect(testDoubleValueA + testDoubleValueB, result.mm);
  });

  test('Add different units', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB = new Measurement(testDoubleValueB, MeasurementUnit.inches);

    var result = testValueA + testValueB;

    expect(testDoubleValueA + (testDoubleValueB * 25.4), result.mm);
  });

  test('Add different units, with other negative', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB = new Measurement(testDoubleValueB, MeasurementUnit.inches);

    var result = testValueA + testValueB;

    expect(testDoubleValueA + (testDoubleValueB * 25.4), result.mm);
  });

  test('Unary negation operator', () {
    var testDoubleValueA = 1.5;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var result = -testValueA;

    expect(-testDoubleValueA, result.mm);
  });

  test('Subtract like units', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var result = testValueA - testValueB;

    expect(testDoubleValueA - testDoubleValueB, result.mm);
  });

  test('Subtract different units', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB = new Measurement(testDoubleValueB, MeasurementUnit.inches);

    var result = testValueA - testValueB;

    expect(testDoubleValueA - (testDoubleValueB * 25.4), result.mm);
  });

  test('Add different units, with other negative', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB = new Measurement(testDoubleValueB, MeasurementUnit.inches);

    var result = testValueA - testValueB;

    expect(testDoubleValueA - (testDoubleValueB * 25.4), result.mm);
  });

  test('Multiply against a "double" factor', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var result = testValueA * testDoubleValueB;

    expect(testDoubleValueA * testDoubleValueB, result.mm);
  });

  test('Divide by a "double" divisor', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var result = testValueA / testDoubleValueB;

    expect(testDoubleValueA / testDoubleValueB, result.mm);
  });

  test('Compare like units "less than"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(true, testValueA < testValueB);
    expect(false, testValueB < testValueA);
  });

  test('Compare different units "less than"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(testDoubleValueA, MeasurementUnit.inches);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(false, testValueA < testValueB);
    expect(true, testValueB < testValueA);
  });

  test('Compare like units "less than or equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var testValueC =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(true, testValueA <= testValueB);
    expect(false, testValueB <= testValueA);
    expect(true, testValueC <= testValueB);
  });

  test('Compare different units "less than or equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var testValueC =
        new Measurement(testDoubleValueB / 25.4, MeasurementUnit.inches);

    expect(false, testValueA <= testValueB);
    expect(true, testValueB <= testValueA);
    expect(true, testValueC <= testValueB);
  });

  test('Compare like units "greater than"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(false, testValueA > testValueB);
    expect(true, testValueB > testValueA);
  });

  test('Compare different units "greater than"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA = new Measurement(testDoubleValueA, MeasurementUnit.inches);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(true, testValueA > testValueB);
    expect(false, testValueB > testValueA);
  });

  test('Compare like units "greater than or equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var testValueC =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(false, testValueA >= testValueB);
    expect(true, testValueB >= testValueA);
    expect(true, testValueC >= testValueB);
  });

  test('Compare different units "greater than or equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var testValueC =
        new Measurement(testDoubleValueB / 25.4, MeasurementUnit.inches);

    expect(true, testValueA >= testValueB);
    expect(false, testValueB >= testValueA);
    expect(true, testValueC <= testValueB);
  });

  test('Compare like units "equal" and "not equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.millimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var testValueC =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(false, testValueA == testValueB);
    expect(false, testValueB == testValueA);
    expect(true, testValueC == testValueB);
  });

  test('Compare different units "equal" and "not equal"', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var testValueC =
        new Measurement(testDoubleValueB / 25.4, MeasurementUnit.inches);

    expect(false, testValueA == testValueB);
    expect(false, testValueB == testValueA);
    expect(true, testValueC == testValueB);
  });

  test('Absolute values', () {
    var testDoubleValueA = -22.5;
    var testDoubleValueB = -testDoubleValueA;
    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    expect(testValueA.abs.cm, testDoubleValueB);
  });

  test('Square roots', () {
    var testDoubleValueA = 4.5;
    var testDoubleValueB = testDoubleValueA * testDoubleValueA;
    var testValueA =
        new Measurement(testDoubleValueB, MeasurementUnit.centimeters);

    expect(testValueA.sqrt.cm, testDoubleValueA);
  });

  test('Exponents', () {
    var testDoubleValueA = -22.5;
    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    expect(testDoubleValueA * testDoubleValueA * testDoubleValueA,
        testValueA.pow(3).cm);
  });

  test('Minimum measurement', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(testValueB, Measurement.min(testValueA, testValueB));
  });

  test('Maximum measurement', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(testValueA, Measurement.max(testValueA, testValueB));
  });

  test('isZero', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = 0.0;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    var testValueC = new Measurement.zero();

    expect(testValueA.isZero, false);
    expect(testValueB.isZero, true);
    expect(testValueC.isZero, true);
  });

  test('isNegative', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(testValueA.isNegative, false);
    expect(testValueB.isNegative, true);
  });

  test('isNaN', () {
    var testDoubleValueA = 1.5;
    var testDoubleValueB = -2.8;

    var testValueA =
        new Measurement(testDoubleValueA, MeasurementUnit.centimeters);

    var testValueB =
        new Measurement(testDoubleValueB, MeasurementUnit.millimeters);

    expect(testValueA.isNaN, false);
    expect(testValueA.sqrt.isNaN, false);
    expect(testValueB.isNaN, false);
    expect(testValueB.sqrt.isNaN, true);
  });

  test('toString', () {
    Measurement a = new Measurement.zero();

    expect(a.toString(), "0.0 pt");

    a.cm = 10.5;
    expect(a.toString(), "10.5 cm");
    a.mm = 100;
    expect(a.toString(), "100.0 mm");
    a.cm = 9.876543;
    expect(a.toString(), "9.877 cm");

    a.cm = -9.876543;
    expect(a.toString(), "-9.877 cm");

    a.inches = 15.5;
    expect(a.toString(), "15 1/2 in");

    a.inches = -15 - 9 / 16;
    expect(a.toString(), "-15 9/16 in");

    a.inches = -15 - 3 / 4;
    expect(a.toString(), "-15 3/4 in");

    a.inches = -15 - 5 / 8;
    expect(a.toString(), "-15 5/8 in");

    a.inches = -15.626;
    expect(a.toString(), "-15 5/8 in");
  });

  test('Parse from string', () {
    expect(Measurement.tryParse("0.0"), null);
    expect(Measurement.tryParse("0.0cm")?.cm, 0.0);
    expect(Measurement.tryParse("10.101cm")?.cm, 10.101);
    expect(Measurement.tryParse("-10.101cm")?.cm, -10.101);

    expect(Measurement.tryParse("10.101 millimeters")?.cm, 1.0101);

    expect(Measurement.tryParse("100 5/8in.")?.inches, 100.625);
    expect(Measurement.tryParse("100.625inches")?.inches, 100.625);
    expect(Measurement.tryParse("-100 5/8in.")?.inches, -100.625);
    expect(Measurement.tryParse("-5/8in.")?.inches, -0.625);
  });
}

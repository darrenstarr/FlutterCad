import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/point.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  test('Constructor and properties', () {
    var testValue = new Point(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValue.x.mm, 10.0);
    expect(testValue.y.mm, 20.0);
  });

  test('Clone and translate', () {
    var testValueA = new Point(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    var testValueB = testValueA.clone();

    expect(testValueB.x.mm, 10.0);
    expect(testValueB.y.mm, 20.0);

    testValueA.translate(new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 20.0);
    expect(testValueA.y.mm, 30.0);

    expect(testValueB.x.mm, 10.0);
    expect(testValueB.y.mm, 20.0);
  });

  test('copyBy', () {
    var testValueA = new Point(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    var testValueB = testValueA.copyBy(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    expect(testValueB.x.mm, 20.0);
    expect(testValueB.y.mm, 30.0);

    testValueA.translate(new Measurement(-10.0, MeasurementUnit.millimeters),
        new Measurement(-10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 0.0);
    expect(testValueA.y.mm, 10.0);

    expect(testValueB.x.mm, 20.0);
    expect(testValueB.y.mm, 30.0);
  });

  // TODO : for clockwise rotation, the x axis should be inverted from what this
  // test reports.
  test('Copy by angle 45 degrees', () {
    var testValueA = new Point(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 10.0);

    var testValueB = testValueA.copyByAngle(
        new Measurement(1.0, MeasurementUnit.millimeters), 45);

    var expectedOffset = math.sqrt(2.0) / 2;
    expect(testValueB.x.mm, testValueA.x.mm - expectedOffset);
    expect(testValueB.y.mm, testValueA.y.mm - expectedOffset);
  });

  test('Distance to another point', () {
    var testValueA = new Point(
        new Measurement(3.0, MeasurementUnit.millimeters),
        new Measurement(0.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(0.0, MeasurementUnit.millimeters),
        new Measurement(4.0, MeasurementUnit.millimeters));

    expect(testValueA.distanceTo(testValueB).mm, 5.0);
  });

  // TODO : for clockwise rotation, the x axis should be inverted from what this
  // test reports.
  test('Angle to another point', () {
    var testValueA = new Point(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(13.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(7.0, MeasurementUnit.millimeters),
        new Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.angleTo(testValueB), 45.0);
  });

  test('Rotate a point around another', () {
    var testValueA = new Point(
        new Measurement(13.0, MeasurementUnit.millimeters),
        new Measurement(13.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(10.0, MeasurementUnit.millimeters));

    var result = testValueA.rotate(testValueB, 180.0);

    expect(result.x.mm.round(), 7.0);
    expect(result.y.mm.round(), 7.0);
  });

  test('Scale from origin by factor', () {
    var testValueA = new Point(
        new Measurement(13.0, MeasurementUnit.millimeters),
        new Measurement(10.0, MeasurementUnit.millimeters));

    var result = testValueA.scaled(3.0);
    expect(result.x.mm, 39.0);
    expect(result.y.mm, 30.0);
  });

  test('Addition operator', () {
    var testValueA = new Point(
        new Measurement(50.0, MeasurementUnit.millimeters),
        new Measurement(13.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(21.0, MeasurementUnit.millimeters));

    var result = testValueA + testValueB;

    expect(result.x.mm, 60.0);
    expect(result.y.mm, 34.0);
  });

  test('Subtraction operator', () {
    var testValueA = new Point(
        new Measurement(50.0, MeasurementUnit.millimeters),
        new Measurement(13.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(21.0, MeasurementUnit.millimeters));

    var result = testValueA - testValueB;

    expect(result.x.mm, 40.0);
    expect(result.y.mm, -8.0);
  });

  test('Multiply by other point', () {
    var testValueA = new Point(
        new Measurement(5.0, MeasurementUnit.millimeters),
        new Measurement(2.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(3.0, MeasurementUnit.millimeters),
        new Measurement(2.0, MeasurementUnit.millimeters));

    var result = testValueA.multiplyBy(testValueB);

    expect(result.x.mm, 15.0);
    expect(result.y.mm, 4.0);
  });

  test('Multiply matrix by scalar', () {
    var testValueA = new Point(
        new Measurement(13.0, MeasurementUnit.millimeters),
        new Measurement(10.0, MeasurementUnit.millimeters));

    var result = testValueA * 3.0;
    expect(result.x.mm, 39.0);
    expect(result.y.mm, 30.0);
  });

  test('Dot product with another point', () {
    var testValueA = new Point(
        new Measurement(-4.0, MeasurementUnit.millimeters),
        new Measurement(-9.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(-1.0, MeasurementUnit.millimeters),
        new Measurement(2.0, MeasurementUnit.millimeters));

    var result = testValueA.dot(testValueB);

    expect(result.mm, -14.0);
  });

  test('Distance Squared, the pythagorean radicand', () {
    var testValueA = new Point(
        new Measurement(0.0, MeasurementUnit.millimeters),
        new Measurement(4.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(3.0, MeasurementUnit.millimeters),
        new Measurement(0.0, MeasurementUnit.millimeters));

    var result = testValueA.distanceToSquared(testValueB);

    expect(result.mm, 25.0);
  });

  test('Equal operator', () {
    var testValueA = new Point(
        new Measurement(0.0, MeasurementUnit.millimeters),
        new Measurement(4.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(3.0, MeasurementUnit.millimeters),
        new Measurement(0.0, MeasurementUnit.millimeters));

    var testValueC = new Point(
        new Measurement(0.0, MeasurementUnit.millimeters),
        new Measurement(4.0, MeasurementUnit.millimeters));

    expect(testValueA == testValueA, true);
    expect(testValueA == testValueB, false);
    expect(testValueB == testValueA, false);
    expect(testValueA == testValueC, true);
  });

  test('Angle between', () {
    var testValueA = new Point(
        new Measurement(0.0, MeasurementUnit.millimeters),
        new Measurement(4.0, MeasurementUnit.millimeters));

    var testValueB = new Point(
        new Measurement(3.0, MeasurementUnit.millimeters),
        new Measurement(0.0, MeasurementUnit.millimeters));

    var testValueC = new Point(
        new Measurement(0.0, MeasurementUnit.millimeters),
        new Measurement(0.0, MeasurementUnit.millimeters));

    expect(testValueC.angleBetween(testValueA, testValueB), -90);
    expect(testValueC.angleBetween(testValueB, testValueA), 90);

    // this is a 3/4/5 triangle and these next two tests verify the angles are
    // 36.87 degrees, 53.13 degrees and of course 90 degrees
    expect((testValueA.angleBetween(testValueC, testValueB) * 100.0).round(),
        3687);
    expect((testValueB.angleBetween(testValueA, testValueC) * 100.0).round(),
        5313);
  });

  test('toString', () {
    var testValueA = new Point(
        new Measurement(86.7548, MeasurementUnit.millimeters),
        new Measurement(123.14, MeasurementUnit.millimeters));

    expect(testValueA.toString(), "(86.755 mm, 123.14 mm)");
  });

  test('String parsing', () {
    expect(Point.tryParse(" (,14mm)"), null);
    expect(Point.tryParse(" (14mm,14mm)"), null);
    expect(Point.tryParse("(14mm,14mm) "), null);

    expect(Point.tryParse("(14mm,16mm)")?.x.mm, 14);
    expect(Point.tryParse("(14mm,16mm)")?.y.mm, 16);

    expect(Point.tryParse("(14mm,16mm )")?.x.mm, 14);
    expect(Point.tryParse("(14mm,16mm )")?.y.mm, 16);

    expect(Point.tryParse("(14mm, 16mm )")?.x.mm, 14);
    expect(Point.tryParse("(14mm, 16mm )")?.y.mm, 16);

    expect(Point.tryParse("(14mm , 16mm )")?.x.mm, 14);
    expect(Point.tryParse("(14mm , 16mm )")?.y.mm, 16);

    expect(Point.tryParse("( 14mm , 16mm )")?.x.mm, 14);
    expect(Point.tryParse("( 14mm , 16mm )")?.y.mm, 16);

    expect(Point.tryParse("( -16.5mm , 22 1/2in. )")?.x.mm, -16.5);
    expect(Point.tryParse("( -16.5mm , 22 1/2in. )")?.y.inches, 22.5);
  });
}

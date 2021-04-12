import 'package:fluttercad/primitives/linesegment.dart';
import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/point.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  test('Constructor and properties', () {
    var testValue = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValue.x.mm, 10.0);
    expect(testValue.y.mm, 20.0);
  });

  test('Clone and translate', () {
    var testValueA = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    var testValueB = testValueA.clone();

    expect(testValueB.x.mm, 10.0);
    expect(testValueB.y.mm, 20.0);

    testValueA.translate(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 20.0);
    expect(testValueA.y.mm, 30.0);

    expect(testValueB.x.mm, 10.0);
    expect(testValueB.y.mm, 20.0);
  });

  test('Clone transposed', () {
    var testValueA = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    var testValueB = testValueA.cloneTransposed();

    expect(testValueB.x.mm, 20.0);
    expect(testValueB.y.mm, 10.0);

    testValueA.translate(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 20.0);
    expect(testValueA.y.mm, 30.0);

    expect(testValueB.x.mm, 20.0);
    expect(testValueB.y.mm, 10.0);
  });

  test('Clone normalized', () {
    var testValueA = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(1.0, MeasurementUnit.inches));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 25.4);

    var testValueB = testValueA.cloneAsUnits(MeasurementUnit.points);

    expect(testValueB.x.value, closeTo(28.3465, 0.1));
    expect(testValueB.y.value, closeTo(72.0, 0.1));

    testValueA.translate(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 20.0);
    expect(testValueA.y.mm, 35.4);

    expect(testValueB.x.value, closeTo(28.3465, 0.1));
    expect(testValueB.y.value, closeTo(72.0, 0.1));
  });

  test('copyBy', () {
    var testValueA = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    var testValueB = testValueA.copyBy(
        Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    expect(testValueB.x.mm, 20.0);
    expect(testValueB.y.mm, 30.0);

    testValueA.translate(Measurement(-10.0, MeasurementUnit.millimeters),
        Measurement(-10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 0.0);
    expect(testValueA.y.mm, 10.0);

    expect(testValueB.x.mm, 20.0);
    expect(testValueB.y.mm, 30.0);
  });

  // TODO : for clockwise rotation, the x axis should be inverted from what this
  // test reports.
  test('Copy by angle 45 degrees', () {
    var testValueA = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 10.0);

    var testValueB = testValueA.copyByAngle(
        Measurement(1.0, MeasurementUnit.millimeters), 45);

    var expectedOffset = math.sqrt(2.0) / 2;
    expect(testValueB.x.mm, testValueA.x.mm - expectedOffset);
    expect(testValueB.y.mm, testValueA.y.mm - expectedOffset);
  });

  test('Distance to another point', () {
    var testValueA = Point(Measurement(3.0, MeasurementUnit.millimeters),
        Measurement(0.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(0.0, MeasurementUnit.millimeters),
        Measurement(4.0, MeasurementUnit.millimeters));

    expect(testValueA.distanceTo(testValueB).mm, 5.0);
  });

  // TODO : for clockwise rotation, the x axis should be inverted from what this
  // test reports.
  test('Angle to another point', () {
    var testValueA = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(13.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(7.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    expect(testValueA.angleTo(testValueB), 45.0);
  });

  test('Rotate a point around another', () {
    var testValueA = Point(Measurement(13.0, MeasurementUnit.millimeters),
        Measurement(13.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    var result = testValueA.rotate(testValueB, 45.0);

    expect(result.x.mm, closeTo(10, 0.01));
    expect(result.y.mm, closeTo(14.25, 0.01));

    result = testValueA.rotate(testValueB, 180.0);

    expect(result.x.mm.round(), 7.0);
    expect(result.y.mm.round(), 7.0);
  });

  test('Scale from origin by factor', () {
    var testValueA = Point(Measurement(13.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    var result = testValueA.scaled(3.0);
    expect(result.x.mm, 39.0);
    expect(result.y.mm, 30.0);
  });

  test('Addition operator', () {
    var testValueA = Point(Measurement(50.0, MeasurementUnit.millimeters),
        Measurement(13.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(21.0, MeasurementUnit.millimeters));

    var result = testValueA + testValueB;

    expect(result.x.mm, 60.0);
    expect(result.y.mm, 34.0);
  });

  test('Subtraction operator', () {
    var testValueA = Point(Measurement(50.0, MeasurementUnit.millimeters),
        Measurement(13.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(21.0, MeasurementUnit.millimeters));

    var result = testValueA - testValueB;

    expect(result.x.mm, 40.0);
    expect(result.y.mm, -8.0);
  });

  test('Multiply by other point', () {
    var testValueA = Point(Measurement(5.0, MeasurementUnit.millimeters),
        Measurement(2.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(3.0, MeasurementUnit.millimeters),
        Measurement(2.0, MeasurementUnit.millimeters));

    var result = testValueA.multiplyBy(testValueB);

    expect(result.x.mm, 15.0);
    expect(result.y.mm, 4.0);
  });

  test('Multiply matrix by scalar', () {
    var testValueA = Point(Measurement(13.0, MeasurementUnit.millimeters),
        Measurement(10.0, MeasurementUnit.millimeters));

    var result = testValueA * 3.0;
    expect(result.x.mm, 39.0);
    expect(result.y.mm, 30.0);
  });

  test('Dot product with another point', () {
    var testValueA = Point(Measurement(-4.0, MeasurementUnit.millimeters),
        Measurement(-9.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(-1.0, MeasurementUnit.millimeters),
        Measurement(2.0, MeasurementUnit.millimeters));

    var result = testValueA.dot(testValueB);

    expect(result.mm, -14.0);
  });

  test('Distance Squared, the pythagorean radicand', () {
    var testValueA = Point(Measurement(0.0, MeasurementUnit.millimeters),
        Measurement(4.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(3.0, MeasurementUnit.millimeters),
        Measurement(0.0, MeasurementUnit.millimeters));

    var result = testValueA.distanceToSquared(testValueB);

    expect(result.mm, 25.0);
  });

  test('Equal operator', () {
    var testValueA = Point(Measurement(0.0, MeasurementUnit.millimeters),
        Measurement(4.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(3.0, MeasurementUnit.millimeters),
        Measurement(0.0, MeasurementUnit.millimeters));

    var testValueC = Point(Measurement(0.0, MeasurementUnit.millimeters),
        Measurement(4.0, MeasurementUnit.millimeters));

    expect(testValueA == testValueA, true);
    expect(testValueA == testValueB, false);
    expect(testValueB == testValueA, false);
    expect(testValueA == testValueC, true);
  });

  test('Angle between', () {
    var testValueA = Point(Measurement(0.0, MeasurementUnit.millimeters),
        Measurement(4.0, MeasurementUnit.millimeters));

    var testValueB = Point(Measurement(3.0, MeasurementUnit.millimeters),
        Measurement(0.0, MeasurementUnit.millimeters));

    var testValueC = Point(Measurement(0.0, MeasurementUnit.millimeters),
        Measurement(0.0, MeasurementUnit.millimeters));

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
    var testValueA = Point(Measurement(86.7548, MeasurementUnit.millimeters),
        Measurement(123.14, MeasurementUnit.millimeters));

    expect(testValueA.toString(), '(86.755mm, 123.14mm)');
  });

  test('String parsing', () {
    expect(Point.tryParse(' (,14mm)'), null);
    expect(Point.tryParse(' (14mm,14mm)'), null);
    expect(Point.tryParse('(14mm,14mm) '), null);

    expect(Point.tryParse('(14mm,16mm)')?.x.mm, 14);
    expect(Point.tryParse('(14mm,16mm)')?.y.mm, 16);

    expect(Point.tryParse('(14mm,16mm )')?.x.mm, 14);
    expect(Point.tryParse('(14mm,16mm )')?.y.mm, 16);

    expect(Point.tryParse('(14mm, 16mm )')?.x.mm, 14);
    expect(Point.tryParse('(14mm, 16mm )')?.y.mm, 16);

    expect(Point.tryParse('(14mm , 16mm )')?.x.mm, 14);
    expect(Point.tryParse('(14mm , 16mm )')?.y.mm, 16);

    expect(Point.tryParse('( 14mm , 16mm )')?.x.mm, 14);
    expect(Point.tryParse('( 14mm , 16mm )')?.y.mm, 16);

    expect(Point.tryParse('( -16.5mm , 22 1/2in. )')?.x.mm, -16.5);
    expect(Point.tryParse('( -16.5mm , 22 1/2in. )')?.y.inches, 22.5);
  });

  test('Rotate point until linear intersection', () {
    var target = LineSegment.tryParse('[(40mm,0mm)-(0mm,30mm)]')!;
    var axis = Point.tryParse('(30mm, 12mm)')!;
    var testPoint = Point.tryParse('(45mm, 12mm)')!;

    var result = testPoint.rotateAroundPointUntilIntersectCW(axis, target)!;

    expect(result.x.mm, closeTo(39.5, 0.1));
    expect(result.y.mm, closeTo(0.4, 0.1));

    result = testPoint.rotateAroundPointUntilIntersectCCW(axis, target)!;

    expect(result.x.mm, closeTo(16.19, 0.1));
    expect(result.y.mm, closeTo(17.85, 0.1));
  });
}

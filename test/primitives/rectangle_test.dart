import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/point.dart';
import 'package:fluttercad/primitives/rectangle.dart';
import 'package:fluttercad/primitives/size.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor and properties', () {
    var testValue1 = Rectangle(
        Point.tryParse('(10mm, 20mm)')!, Size.tryParse('(100mm, 200mm)')!);

    expect(testValue1.x.mm, 10.0);
    expect(testValue1.y.mm, 20.0);
    expect(testValue1.width.mm, 100.0);
    expect(testValue1.height.mm, 200.0);

    var testValue2 = Rectangle.metrics(
        Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters),
        Measurement(100.0, MeasurementUnit.millimeters),
        Measurement(200.0, MeasurementUnit.millimeters));

    expect(testValue2.x.mm, 10.0);
    expect(testValue2.y.mm, 20.0);
    expect(testValue2.width.mm, 100.0);
    expect(testValue2.height.mm, 200.0);

    expect(testValue2.left.mm, 10.0);
    expect(testValue2.top.mm, 20.0);
    expect(testValue2.right.mm, 110.0);
    expect(testValue2.bottom.mm, 220.0);

    expect(testValue2.x1.mm, 10.0);
    expect(testValue2.y1.mm, 20.0);
    expect(testValue2.x2.mm, 110.0);
    expect(testValue2.y2.mm, 220.0);

    expect(testValue2.bottomRight.x.mm, 110.0);
    expect(testValue2.bottomRight.y.mm, 220.0);

    // TODO: Write code to test all set accessors

    var testValue3 = Rectangle.coordinates(
        Point.tryParse('(10mm, 20mm)')!, Point.tryParse('(110mm, 220mm)')!);
    expect(testValue3.left.mm, 10.0);
    expect(testValue3.top.mm, 20.0);
    expect(testValue3.right.mm, 110.0);
    expect(testValue3.bottom.mm, 220.0);

    var testValue4 = Rectangle.edges(
        Measurement(10, MeasurementUnit.millimeters),
        Measurement(20, MeasurementUnit.millimeters),
        Measurement(110, MeasurementUnit.millimeters),
        Measurement(220, MeasurementUnit.millimeters));
    expect(testValue4.left.mm, 10.0);
    expect(testValue4.top.mm, 20.0);
    expect(testValue4.right.mm, 110.0);
    expect(testValue4.bottom.mm, 220.0);
  });

  test('Clone', () {
    var testValue = Rectangle.tryParse('(10mm, 20mm, 100mm, 200mm)')!;

    var cloned = testValue.clone();

    expect(testValue.x.mm, 10.0);
    expect(testValue.y.mm, 20.0);
    expect(testValue.width.mm, 100.0);
    expect(testValue.height.mm, 200.0);

    expect(cloned.x.mm, 10.0);
    expect(cloned.y.mm, 20.0);
    expect(cloned.width.mm, 100.0);
    expect(cloned.height.mm, 200.0);

    testValue.x.mm = 100;
    testValue.y.mm = 110;
    testValue.width.mm = 200;
    testValue.height.mm = 400;

    expect(testValue.x.mm, 100.0);
    expect(testValue.y.mm, 110.0);
    expect(testValue.width.mm, 200.0);
    expect(testValue.height.mm, 400.0);

    expect(cloned.x.mm, 10.0);
    expect(cloned.y.mm, 20.0);
    expect(cloned.width.mm, 100.0);
    expect(cloned.height.mm, 200.0);
  });

  test('Clone normalized', () {
    var testValue = Rectangle.tryParse('(10mm, 20cm, 4in, 144pt)')!;

    var cloned = testValue.cloneAsUnits(MeasurementUnit.millimeters);

    expect(testValue.x.mm, 10.0);
    expect(testValue.y.mm, 200.0);
    expect(testValue.width.mm, 101.6);
    expect(testValue.height.mm, 50.8);

    expect(cloned.x.value, 10.0);
    expect(cloned.y.value, 200.0);
    expect(cloned.width.value, 101.6);
    expect(cloned.height.value, 50.8);
  });

  test('toString', () {
    var testValue1 = Rectangle(
        Point.tryParse('(10mm, 20mm)')!, Size.tryParse('(100mm, 200mm)')!);

    expect(testValue1.toString(), '(10.0mm, 20.0mm, 100.0mm, 200.0mm)');
  });

  test('String parsing', () {
    var testValue1 = Rectangle.tryParse('(10mm, 20mm, 100mm, 200mm)')!;
    expect(testValue1.x.mm, 10.0);
    expect(testValue1.y.mm, 20.0);
    expect(testValue1.width.mm, 100.0);
    expect(testValue1.height.mm, 200.0);

    var testValue2 = Rectangle.tryParse('(10mm, 20mm)-(110mm, 220mm)')!;
    expect(testValue2.x.mm, 10.0);
    expect(testValue2.y.mm, 20.0);
    expect(testValue2.width.mm, 100.0);
    expect(testValue2.height.mm, 200.0);
  });

  test('Normalization', () {
    var testValue1 = Rectangle.tryParse('(10mm, 20mm, -100mm, -200mm)')!;
    expect(testValue1.x.mm, 10.0);
    expect(testValue1.y.mm, 20.0);
    expect(testValue1.width.mm, -100.0);
    expect(testValue1.height.mm, -200.0);

    testValue1.normalize();
    expect(testValue1.x.mm, -90.0);
    expect(testValue1.y.mm, -180.0);
    expect(testValue1.width.mm, 100.0);
    expect(testValue1.height.mm, 200.0);

    var testValue2 = Rectangle.tryParse('(10mm, 20mm)-(-110mm, -220mm)')!;
    expect(testValue2.x.mm, 10.0);
    expect(testValue2.y.mm, 20.0);
    expect(testValue2.width.mm, -120.0);
    expect(testValue2.height.mm, -240.0);

    var testValue3 = testValue2.cloneNormalized();

    expect(testValue2.x.mm, 10.0);
    expect(testValue2.y.mm, 20.0);
    expect(testValue2.width.mm, -120.0);
    expect(testValue2.height.mm, -240.0);
    expect(testValue3.x.mm, -110.0);
    expect(testValue3.y.mm, -220.0);
    expect(testValue3.width.mm, 120.0);
    expect(testValue3.height.mm, 240.0);
  });

  test('Combined', () {
    var testValue1 = Rectangle.tryParse('(10mm,20mm,100mm,100mm)')!;
    var testValue2 = Rectangle.tryParse('(50mm,70mm,100mm,100mm)')!;

    testValue1.Join(testValue2);
    expect(testValue1.x.mm, 10.0);
    expect(testValue1.y.mm, 20.0);
    expect(testValue1.width.mm, 140.0);
    expect(testValue1.height.mm, 150.0);

    var testValue3 = Rectangle.tryParse('(50mm,40mm,-100mm,-100mm)')!;
    var result = testValue1.cloneCombined(testValue3);

    expect(testValue1.x.mm, 10.0);
    expect(testValue1.y.mm, 20.0);
    expect(testValue1.width.mm, 140.0);
    expect(testValue1.height.mm, 150.0);

    expect(result.x.mm, -50.0);
    expect(result.y.mm, -60.0);
    expect(result.width.mm, 200.0);
    expect(result.height.mm, 230.0);
  });

  test('Addition operator', () {
    var testValue1 = Rectangle.tryParse('(10mm,20mm,100mm,100mm)')!;
    var testValue2 = Size.tryParse('(100mm,200mm)')!;

    var result = testValue1 + testValue2;
    expect(result.x.mm, 10.0);
    expect(result.y.mm, 20.0);
    expect(result.width.mm, 200.0);
    expect(result.height.mm, 300.0);

    var testValue3 = Point.tryParse('(10mm, 30mm)')!;
    result = testValue1 + testValue3;
    expect(result.x.mm, 20.0);
    expect(result.y.mm, 50.0);
    expect(result.width.mm, 110.0);
    expect(result.height.mm, 120.0);
  });

  test('Subtraction operator', () {
    var testValue1 = Rectangle.tryParse('(10mm,20mm,100mm,100mm)')!;
    var testValue2 = Size.tryParse('(100mm,200mm)')!;

    var result = testValue1 - testValue2;
    expect(result.x.mm, 10.0);
    expect(result.y.mm, 20.0);
    expect(result.width.mm, 0.0);
    expect(result.height.mm, -100.0);

    var testValue3 = Point.tryParse('(10mm, 30mm)')!;
    result = testValue1 - testValue3;
    expect(result.x.mm, 0.0);
    expect(result.y.mm, -10.0);
    expect(result.width.mm, 110.0);
    expect(result.height.mm, 120.0);
  });
}

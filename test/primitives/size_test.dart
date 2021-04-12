import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/point.dart';
import 'package:fluttercad/primitives/size.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor and properties', () {
    var testValue = Size(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValue.width.mm, 10.0);
    expect(testValue.height.mm, 20.0);
  });

  test('Clone', () {
    var testValue = Size(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters));

    var cloned = testValue.clone();

    expect(testValue.width.mm, 10.0);
    expect(testValue.height.mm, 20.0);

    expect(cloned.width.mm, 10.0);
    expect(cloned.height.mm, 20.0);

    testValue.width.mm = 100;
    testValue.height.mm = 200;

    expect(testValue.width.mm, 100.0);
    expect(testValue.height.mm, 200.0);

    expect(cloned.width.mm, 10.0);
    expect(cloned.height.mm, 20.0);
  });

  test('Clone normalized', () {
    var testValue = Size(Measurement(4.0, MeasurementUnit.inches),
        Measurement(72.0, MeasurementUnit.points));

    var cloned = testValue.cloneAsUnits(MeasurementUnit.millimeters);

    expect(testValue.width.mm, 101.6);
    expect(testValue.height.mm, 25.4);

    expect(cloned.width.value, 101.6);
    expect(cloned.height.value, 25.4);
  });

  test('Grow and shrink', () {
    var testValue = Size(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters));

    testValue.grow(Measurement(50.0, MeasurementUnit.millimeters),
        Measurement(-50.0, MeasurementUnit.millimeters));

    expect(testValue.width.mm, 60);
    expect(testValue.height.mm, -30);
  });

  test('Transpose in place', () {
    var testValue = Size(Measurement(10.0, MeasurementUnit.millimeters),
        Measurement(20.0, MeasurementUnit.millimeters));

    testValue.transpose();

    expect(testValue.width.mm, 20);
    expect(testValue.height.mm, 10);
  });

  test('Convert from point', () {
    var p = Point.tryParse('(10.0mm, 20.0mm)')!;
    var result = Size.fromPoint(p);

    expect(result.width.mm, 10.0);
    expect(result.height.mm, 20.0);
  });

  test('String parsing', () {
    expect(Size.tryParse(' (,14mm)'), null);
    expect(Size.tryParse(' (14mm,14mm)'), null);
    expect(Size.tryParse('(14mm,14mm) '), null);

    expect(Size.tryParse('(14mm,16mm)')?.width.mm, 14);
    expect(Size.tryParse('(14mm,16mm)')?.height.mm, 16);

    expect(Size.tryParse('(14mm,16mm )')?.width.mm, 14);
    expect(Size.tryParse('(14mm,16mm )')?.height.mm, 16);

    expect(Size.tryParse('(14mm, 16mm )')?.width.mm, 14);
    expect(Size.tryParse('(14mm, 16mm )')?.height.mm, 16);

    expect(Size.tryParse('(14mm , 16mm )')?.width.mm, 14);
    // ignore: prefer_single_quotes
    expect(Size.tryParse("(14mm , 16mm )")?.height.mm, 16);

    expect(Size.tryParse('( 14mm , 16mm )')?.width.mm, 14);
    expect(Size.tryParse('( 14mm , 16mm )')?.height.mm, 16);

    expect(Size.tryParse('( -16.5mm , 22 1/2in. )')?.width.mm, -16.5);
    expect(Size.tryParse('( -16.5mm , 22 1/2in. )')?.height.inches, 22.5);
  });
}

import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/size.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor and properties', () {
    var testValue = new Size(new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(20.0, MeasurementUnit.millimeters));

    expect(testValue.width.mm, 10.0);
    expect(testValue.height.mm, 20.0);
  });

  test('Clone', () {
    var testValue = new Size(new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(20.0, MeasurementUnit.millimeters));

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
    var testValue = new Size(new Measurement(4.0, MeasurementUnit.inches),
        new Measurement(72.0, MeasurementUnit.points));

    var cloned = testValue.cloneAsUnits(MeasurementUnit.millimeters);

    expect(testValue.width.mm, 101.6);
    expect(testValue.height.mm, 25.4);

    expect(cloned.width.value, 101.6);
    expect(cloned.height.value, 25.4);
  });

  test('Grow and shrink', () {
    var testValue = new Size(new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(20.0, MeasurementUnit.millimeters));

    testValue.grow(new Measurement(50.0, MeasurementUnit.millimeters),
        new Measurement(-50.0, MeasurementUnit.millimeters));

    expect(testValue.width.mm, 60);
    expect(testValue.height.mm, -30);
  });

  test('Transpose in place', () {
    var testValue = new Size(new Measurement(10.0, MeasurementUnit.millimeters),
        new Measurement(20.0, MeasurementUnit.millimeters));

    testValue.transpose();

    expect(testValue.width.mm, 20);
    expect(testValue.height.mm, 10);
  });
}

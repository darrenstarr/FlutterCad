import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/point.dart';
import 'package:test/test.dart';

void main() {
  test('Test constructor and properties', () {
    var testValue = new Point(
        x: new Measurement(value: 10.0, units: MeasurementUnit.millimeters),
        y: new Measurement(value: 20.0, units: MeasurementUnit.millimeters));

    expect(testValue.x.mm, 10.0);
    expect(testValue.y.mm, 20.0);
  });

  test('Test clone and translate', () {
    var testValueA = new Point(
        x: new Measurement(value: 10.0, units: MeasurementUnit.millimeters),
        y: new Measurement(value: 20.0, units: MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    var testValueB = testValueA.clone();

    expect(testValueB.x.mm, 10.0);
    expect(testValueB.y.mm, 20.0);

    testValueA.translate(
        new Measurement(value: 10.0, units: MeasurementUnit.millimeters),
        new Measurement(value: 10.0, units: MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 20.0);
    expect(testValueA.y.mm, 30.0);

    expect(testValueB.x.mm, 10.0);
    expect(testValueB.y.mm, 20.0);
  });

  test('Test copyBy', () {
    var testValueA = new Point(
        x: new Measurement(value: 10.0, units: MeasurementUnit.millimeters),
        y: new Measurement(value: 20.0, units: MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    var testValueB = testValueA.copyBy(
        new Measurement(value: 10.0, units: MeasurementUnit.millimeters),
        new Measurement(value: 10.0, units: MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 10.0);
    expect(testValueA.y.mm, 20.0);

    expect(testValueB.x.mm, 20.0);
    expect(testValueB.y.mm, 30.0);

    testValueA.translate(
        new Measurement(value: -10.0, units: MeasurementUnit.millimeters),
        new Measurement(value: -10.0, units: MeasurementUnit.millimeters));

    expect(testValueA.x.mm, 0.0);
    expect(testValueA.y.mm, 10.0);

    expect(testValueB.x.mm, 20.0);
    expect(testValueB.y.mm, 30.0);
  });
}

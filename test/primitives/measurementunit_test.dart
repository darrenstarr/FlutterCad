import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:test/test.dart';

void main() {
  test('Short name parsing', () {
    expect(tryParseMeasurementUnit('cm'), MeasurementUnit.centimeters);
    expect(tryParseMeasurementUnit('mm'), MeasurementUnit.millimeters);
    expect(tryParseMeasurementUnit('in'), MeasurementUnit.inches);
    expect(tryParseMeasurementUnit('pt'), MeasurementUnit.points);

    expect(tryParseMeasurementUnit('pts'), null);

    expect(tryParseMeasurementUnit(' \tcm'), MeasurementUnit.centimeters);
    expect(tryParseMeasurementUnit('\t mm'), MeasurementUnit.millimeters);
    expect(tryParseMeasurementUnit('  in'), MeasurementUnit.inches);
    expect(tryParseMeasurementUnit('   \t\tpt'), MeasurementUnit.points);

    expect(tryParseMeasurementUnit(' cm.'), MeasurementUnit.centimeters);
    expect(tryParseMeasurementUnit(' mm.'), MeasurementUnit.millimeters);
    expect(tryParseMeasurementUnit(' in.'), MeasurementUnit.inches);
    expect(tryParseMeasurementUnit(' pt.'), MeasurementUnit.points);

    expect(tryParseMeasurementUnit(' cm. '), null);
    expect(tryParseMeasurementUnit(' mm. '), null);
    expect(tryParseMeasurementUnit(' in. '), null);
    expect(tryParseMeasurementUnit(' pt. '), null);
  });

  test('Long name parsing', () {
    expect(tryParseMeasurementUnit('centimeters'), MeasurementUnit.centimeters);
    expect(tryParseMeasurementUnit('millimeters'), MeasurementUnit.millimeters);
    expect(tryParseMeasurementUnit('inches'), MeasurementUnit.inches);
    expect(tryParseMeasurementUnit('points'), MeasurementUnit.points);

    expect(
        tryParseMeasurementUnit(' \tcentimeters'), MeasurementUnit.centimeters);
    expect(tryParseMeasurementUnit('\t\tmillimeters'),
        MeasurementUnit.millimeters);
    expect(tryParseMeasurementUnit('    inches'), MeasurementUnit.inches);
    expect(tryParseMeasurementUnit('\t   points'), MeasurementUnit.points);

    expect(tryParseMeasurementUnit('centimeter'), MeasurementUnit.centimeters);
    expect(tryParseMeasurementUnit('millimeter'), MeasurementUnit.millimeters);
    expect(tryParseMeasurementUnit('inche'), MeasurementUnit.inches);
    expect(tryParseMeasurementUnit('point'), MeasurementUnit.points);

    expect(tryParseMeasurementUnit('centimete'), null);
    expect(tryParseMeasurementUnit('millimete'), null);
    expect(tryParseMeasurementUnit('inc'), null);
    expect(tryParseMeasurementUnit('poin'), null);

    expect(tryParseMeasurementUnit('centimeterr'), null);
    expect(tryParseMeasurementUnit('millimeter '), null);
    expect(tryParseMeasurementUnit('inchf'), null);
    expect(tryParseMeasurementUnit('pointss'), null);
  });
}

import 'package:fluttercad/primitives/linesegment.dart';
import 'package:fluttercad/primitives/measurement.dart';
import 'package:fluttercad/primitives/measurement_unit.dart';
import 'package:fluttercad/primitives/point.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor and properties', () {
    var testSegmentA = LineSegment.zero();

    expect(testSegmentA.a.x.mm, 0);
    expect(testSegmentA.a.y.mm, 0);
    expect(testSegmentA.b.x.mm, 0);
    expect(testSegmentA.b.y.mm, 0);

    var testSegmentB =
        LineSegment(Point.tryParse('(5mm,6mm)')!, Point.tryParse('(8mm,9mm)')!);

    expect(testSegmentB.a.x.mm, 5);
    expect(testSegmentB.a.y.mm, 6);
    expect(testSegmentB.b.x.mm, 8);
    expect(testSegmentB.b.y.mm, 9);
  });

  test('toString', () {
    var testSegmentB =
        LineSegment(Point.tryParse('(5mm,6mm)')!, Point.tryParse('(8mm,9mm)')!);

    expect(testSegmentB.toString(), '[(5.0mm, 6.0mm)-(8.0mm, 9.0mm)]');
  });

  test('Parse string', () {
    expect(LineSegment.tryParse('[(0mm,0cm)-(0.0pt, 0 in.)]')?.a.x.mm, 0);
    expect(LineSegment.tryParse('[(0mm,0cm)-(0.0pt, 0 in.)]')?.a.y.mm, 0);
    expect(LineSegment.tryParse('[(0mm,0cm)-(0.0pt, 0 in.)]')?.b.x.mm, 0);
    expect(LineSegment.tryParse('[(0mm,0cm)-(0.0pt, 0 in.)]')?.b.y.mm, 0);

    expect(LineSegment.tryParse('[ (0mm, 0.999cm) - (0.0pt, 0 in.) ]')?.a.y.mm,
        9.99);

    expect(LineSegment.tryParse('[(-5mm,-2mm)-(15mm,6mm)]')?.a.x.mm, -5);
  });

  test('Clone and normalized clone', () {
    var segmentAB = LineSegment.tryParse('[(10mm,1in)-(72pt,1cm)]')!;
    var result1 = segmentAB.clone();

    expect(result1.a.x.mm, 10);
    expect(result1.a.y.inches, 1);
    expect(result1.b.x.points, 72);
    expect(result1.b.y.cm, 1);

    segmentAB.a.x.mm = 30;

    expect(segmentAB.a.x.mm, 30);

    expect(result1.a.x.mm, 10);
    expect(result1.a.y.inches, 1);
    expect(result1.b.x.points, 72);
    expect(result1.b.y.cm, 1);

    var result2 = segmentAB.cloneAsUnits(MeasurementUnit.millimeters);
    expect(result2.a.x.value, 30);
    expect(result2.a.y.value, 25.4);
    expect(result2.b.x.value, 25.4);
    expect(result2.b.y.value, 10);
  });

  test('Midpoint/bisect', () {
    expect(LineSegment.tryParse('[(-5mm,-2mm)-(15mm,6mm)]')?.bisect(),
        Point.tryParse('(5mm,2mm)')!);
  });

  test('Line segment length', () {
    expect(LineSegment.tryParse('[(4mm,0mm)-(0mm,3mm)]')?.length.mm, 5);
  });

  test('Set segment length', () {
    var testSegmentA = LineSegment.tryParse('[(4mm,0mm)-(0mm,3mm)]')!;
    testSegmentA.length = Measurement(10.0, MeasurementUnit.millimeters);

    expect(testSegmentA.b.x.mm, closeTo(-4, 0.00001));
    expect(testSegmentA.b.y.mm, closeTo(6, 0.00001));
  });

  // Test of segment rotation
  // the values for the test are taken from plotting the points in
  // Affinity Designer and rotating around the other point
  test('Rotate segment', () {
    var testSegmentA = LineSegment.tryParse('[(4mm,0mm)-(0mm,3mm)]')!;
    testSegmentA.rotate(Point.tryParse('(1mm, 1mm)')!, 90);

    expect(testSegmentA.a.x.mm, closeTo(2, 0.00001));
    expect(testSegmentA.a.y.mm, closeTo(4, 0.00001));
    expect(testSegmentA.b.x.mm, closeTo(-1, 0.00001));
    expect(testSegmentA.b.y.mm, closeTo(0, 0.00001));
  });

  test('Ortaganol bisecting segment', () {
    var testSegmentA = LineSegment.tryParse('[(40mm,0mm)-(0mm,30mm)]')!;
    var cwLength = Measurement(10, MeasurementUnit.millimeters);
    var ccwLength = Measurement(20, MeasurementUnit.millimeters);
    var result = testSegmentA.bisectingSegment(cwLength, ccwLength);

    expect(result.a.x.mm, closeTo(14, 0.00001));
    expect(result.a.y.mm, closeTo(7, 0.00001));
    expect(result.b.x.mm, closeTo(32, 0.00001));
    expect(result.b.y.mm, closeTo(31, 0.00001));
  });

  test('Find point of intersection of two segments', () {
    var testSegmentA = LineSegment.tryParse('[(40mm,0mm)-(0mm,30mm)]')!;
    var testSegmentB = LineSegment.tryParse('[(14mm,7mm)-(32mm,31mm)]')!;

    var result = testSegmentA.findSegmentIntersection(testSegmentB)!;

    expect(result.x.mm, closeTo(20, 0.0001));
    expect(result.y.mm, closeTo(15, 0.0001));
  });

  test('Find point along ray', () {
    var testSegmentA = LineSegment.tryParse('[(40mm,0mm)-(0mm,30mm)]')!;
    var result = testSegmentA.along(2.0);

    expect(result.x.mm, closeTo(-40, 0.0001));
    expect(result.y.mm, closeTo(60, 0.0001));
  });

  test('Extend line by distance', () {
    var testSegmentA = LineSegment.tryParse('[(40mm,0mm)-(0mm,30mm)]')!;
    var result =
        testSegmentA.extendedBy(Measurement(50, MeasurementUnit.millimeters));

    expect(result.a.x.mm, closeTo(40, 0.0001));
    expect(result.a.y.mm, closeTo(0, 0.0001));
    expect(result.b.x.mm, closeTo(-40, 0.0001));
    expect(result.b.y.mm, closeTo(60, 0.0001));
  });

  test('Copy line with new distance', () {
    var testSegmentA = LineSegment.tryParse('[(40mm,0mm)-(0mm,30mm)]')!;
    var result =
        testSegmentA.withLength(Measurement(100, MeasurementUnit.millimeters));

    expect(result.a.x.mm, closeTo(40, 0.0001));
    expect(result.a.y.mm, closeTo(0, 0.0001));
    expect(result.b.x.mm, closeTo(-40, 0.0001));
    expect(result.b.y.mm, closeTo(60, 0.0001));
  });

  test('Slope', () {
    expect(LineSegment.tryParse('[(40mm,0mm)-(0mm,30mm)]')?.slope, -3.0 / 4.0);
    expect(LineSegment.tryParse('[(40mm,0mm)-(40mm,30mm)]')?.slope,
        double.infinity);
  });

  test('Rotate until resting on', () {
    var testSegmentCD = LineSegment.tryParse('[(20mm,5mm)-(20mm,35mm)]')!;

    var setSegmentAB1 = LineSegment.tryParse('[(30mm,12mm)-(41mm,20mm)]')!;
    var result1cw = setSegmentAB1.rotateCWUntilIntersectionWith(testSegmentCD);
    expect(result1cw, null);

    var result1ccw =
        setSegmentAB1.rotateCCWUntilIntersectionWith(testSegmentCD)!;
    expect(result1ccw.b.x.mm, 20.0);
    expect(result1ccw.b.y.mm, closeTo(21.2, 0.1));
  });

  test('Nearest point', () {
    var segmentAB = LineSegment.tryParse('[(30mm,12mm)-(41mm,20mm)]')!;
    var pointP = Point.tryParse('(35mm, 19mm)')!;

    var result = segmentAB.nearestPoint(pointP);

    expect(result.x.mm, closeTo(36.6, 0.1));
    expect(result.y.mm, closeTo(16.8, 0.1));
  });

  test('Extents', () {
    var segmentAB = LineSegment.tryParse('[(130mm,212mm)-(41mm,20mm)]')!;
    var result = segmentAB.extents();

    expect(result.left.mm, 41);
    expect(result.top.mm, 20);
    expect(result.right.mm, 130);
    expect(result.bottom.mm, 212);
  });
}

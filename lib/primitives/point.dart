import 'measurement.dart';

/// Represents a point based on measurements
class Point {
  /// The X coordinate
  Measurement x = new Measurement();

  /// The Y coordinate
  Measurement y = new Measurement();

  /// Constructor
  ///
  /// @param the X coordinate
  /// @param the Y coordinate
  Point({this.x, this.y});

  /// Deep copy the point
  ///
  /// @return The new point
  Point clone() => new Point(x: x, y: y);

  /// Create a new point offset by the given offsets
  ///
  /// @param offsetX the X offset from this point
  /// @param offsetY the Y offset from this point
  /// @return the new point
  Point copyBy(Measurement offsetX, Measurement offsetY) =>
      new Point(x: x + offsetX, y: y + offsetY);

  /// Translate this point by the given offsets
  ///
  /// @param offsetX the X offset from the original point
  /// @param offsetY the Y offset from the original point
  translate(Measurement offsetX, Measurement offsetY) {
    x += offsetX;
    y += offsetY;
  }
}

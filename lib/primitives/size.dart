import 'measurement.dart';
import 'measurement_unit.dart';

/// Class to implement the geometric representation of size
class Size {
  Measurement width;
  Measurement height;

  /// Default constructor
  Size(this.width, this.height);

  /// Zero constructor
  Size.zero()
      : width = new Measurement.zero(),
        height = new Measurement.zero();

  /// Deep copy
  ///
  /// @return a deep copy of this value
  Size clone() => new Size(width.clone(), height.clone());

  /// Deep copy with units normalization
  ///
  /// @param destinationUnits the desired output units format
  /// @return the cloned value
  Size cloneAsUnits(MeasurementUnit destinationUnits) => new Size(
      width.cloneConverted(destinationUnits),
      height.cloneConverted(destinationUnits));

  /// Alter the size of the... size by the given amounts
  ///
  /// @param growByX the amount to change the width
  /// @param growByY the amount to change the height
  grow(Measurement growByX, Measurement growByY) {
    width += growByX;
    height += growByY;
  }

  /// Switch the values for width and height
  transpose() {
    var temp = width;
    width = height;
    height = temp;
  }
}

part of 'src.dart';

/// Represents a serializable value to be serialized
/// for saving and restoring.
mixin QudsSerializable {
  /// Generate a json map of this object.
  Map<String, dynamic> toJson();

  /// Fill values of this object from a json map
  void fromJson(Map<String, dynamic> json);
}

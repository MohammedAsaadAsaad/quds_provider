part of quds_provider;

///Represents a serializable value to be serialized
///for saving and restoring.
mixin QudsSerializable {
  Map<String, dynamic> toJson();
  void fromJson(Map<String, dynamic> json);
}

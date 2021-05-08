part of quds_provider;

mixin QudsSerializable {
  Map<String, dynamic> toJson();
  void fromJson(Map<String, dynamic> json);
}

import 'package:json_annotation/json_annotation.dart';
part 'specialization.g.dart';

@JsonSerializable()
class Specialization {
  int? specializationId;
  String? name;
  String? description;


  Specialization();

  factory Specialization.fromJson(Map<String, dynamic> json) =>
      _$SpecializationFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SpecializationToJson(this);
}
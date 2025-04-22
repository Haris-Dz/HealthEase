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

  Map<String, dynamic> toJson() => _$SpecializationToJson(this);
}

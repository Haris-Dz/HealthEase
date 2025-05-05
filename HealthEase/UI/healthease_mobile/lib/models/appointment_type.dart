import 'package:json_annotation/json_annotation.dart';
part 'appointment_type.g.dart';

@JsonSerializable()
class AppointmentType {
  int? appointmentTypeId;
  String? name;
  double? price;

  AppointmentType();

  factory AppointmentType.fromJson(Map<String, dynamic> json) =>
      _$AppointmentTypeFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AppointmentTypeToJson(this);
}

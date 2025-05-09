import 'package:healthease_mobile/models/specialization.dart';
import 'package:healthease_mobile/models/user.dart';
import 'package:healthease_mobile/models/workingHours.dart';
import 'package:json_annotation/json_annotation.dart';
part 'doctor.g.dart';

@JsonSerializable()
class Doctor {
  int? doctorId;
  String? biography;
  String? title;
  String? stateMachine;
  User? user;
  List<Specialization>? doctorSpecializations;
  List<WorkingHours>? workingHours;

  Doctor();

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}

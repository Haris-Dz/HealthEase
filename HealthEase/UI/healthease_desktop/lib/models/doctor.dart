import 'package:healthease_desktop/models/specialization.dart';
import 'package:healthease_desktop/models/user.dart';
import 'package:healthease_desktop/models/working_hours.dart';
import 'package:json_annotation/json_annotation.dart';
part 'doctor.g.dart';

@JsonSerializable()
class Doctor {
  int? doctorId;
  int? userId;
  String? biography;
  String? title;
  String? stateMachine;
  User? user;
  List<Specialization>? doctorSpecializations;
  List<WorkingHours>? workingHours;

  Doctor();

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}

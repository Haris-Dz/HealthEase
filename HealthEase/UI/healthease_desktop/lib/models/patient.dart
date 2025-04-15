
import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
part 'patient.g.dart';

@JsonSerializable()
class Patient {
  int? patientId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? username;
  String? profilePicture;
  String? registrationDate;
  bool? isActive;

  Patient();

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

      Map<String, dynamic> toJson() => _$PatientToJson(this);
}
import 'package:healthease_mobile/models/appointment_type.dart';
import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/models/patient.dart';
import 'package:json_annotation/json_annotation.dart';
part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  int? appointmentId;
  String? appointmentDate;
  String? appointmentTime;
  String? status;
  String? statusMessage;
  String? note;
  bool? isPaid;
  String? paymentDate;
  int? doctorId;
  int? patientId;
  int? appointmentTypeId;
  Doctor? doctor;
  Patient? patient;
  AppointmentType? appointmentType;

  Appointment();

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}

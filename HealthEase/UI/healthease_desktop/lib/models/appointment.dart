import 'package:healthease_desktop/models/appointment_type.dart';
import 'package:healthease_desktop/models/doctor.dart';
import 'package:healthease_desktop/models/patient.dart';
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

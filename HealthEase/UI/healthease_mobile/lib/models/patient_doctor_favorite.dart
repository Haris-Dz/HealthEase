import 'package:healthease_mobile/models/doctor.dart';
import 'package:json_annotation/json_annotation.dart';
part 'patient_doctor_favorite.g.dart';

@JsonSerializable()
class PatientDoctorFavorite {
  int? patientId;
  int? doctorId;
  String? createdAt;
  Doctor? doctor;

  PatientDoctorFavorite();

  factory PatientDoctorFavorite.fromJson(Map<String, dynamic> json) =>
      _$PatientDoctorFavoriteFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PatientDoctorFavoriteToJson(this);
}

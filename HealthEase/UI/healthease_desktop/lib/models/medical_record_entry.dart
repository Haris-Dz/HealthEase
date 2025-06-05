import 'package:json_annotation/json_annotation.dart';

part 'medical_record_entry.g.dart';

@JsonSerializable()
class MedicalRecordEntry {
  int? medicalRecordEntryId;
  int? medicalRecordId;
  int? doctorId;
  String? entryType;
  String? entryDate;
  String? title;
  String? description;

  MedicalRecordEntry();

  factory MedicalRecordEntry.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordEntryFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MedicalRecordEntryToJson(this);
}

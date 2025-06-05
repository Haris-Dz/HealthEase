import 'package:healthease_desktop/models/medical_record_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medical_record.g.dart';

@JsonSerializable()
class MedicalRecord {
  int? medicalRecordId;
  int? patientId;
  String? notes;
  List<MedicalRecordEntry>? entries;

  MedicalRecord();

  factory MedicalRecord.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MedicalRecordToJson(this);
}

import 'package:healthease_desktop/models/medical_record.dart';
import 'package:healthease_desktop/providers/base_provider.dart';

class MedicalRecordsProvider extends BaseProvider<MedicalRecord> {
  MedicalRecordsProvider() : super("MedicalRecord");
  @override
  MedicalRecord fromJson(data) {
    // TODO: implement fromJson
    return MedicalRecord.fromJson(data);
  }
}

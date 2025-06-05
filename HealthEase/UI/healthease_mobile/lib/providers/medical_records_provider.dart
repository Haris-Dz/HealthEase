import 'package:healthease_mobile/models/medical_record.dart';
import 'package:healthease_mobile/providers/base_provider.dart';

class MedicalRecordsProvider extends BaseProvider<MedicalRecord> {
  MedicalRecordsProvider() : super("MedicalRecord");
  @override
  MedicalRecord fromJson(data) {
    // TODO: implement fromJson
    return MedicalRecord.fromJson(data);
  }
}

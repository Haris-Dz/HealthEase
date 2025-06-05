import 'package:healthease_mobile/models/medical_record_entry.dart';
import 'package:healthease_mobile/providers/base_provider.dart';

class MedicalRecordEntriesProvider extends BaseProvider<MedicalRecordEntry> {
  MedicalRecordEntriesProvider() : super("MedicalRecordEntry");
  @override
  MedicalRecordEntry fromJson(data) {
    // TODO: implement fromJson
    return MedicalRecordEntry.fromJson(data);
  }
}

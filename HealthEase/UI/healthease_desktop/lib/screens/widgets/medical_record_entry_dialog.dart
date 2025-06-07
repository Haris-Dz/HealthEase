import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/medical_record_entry.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/providers/doctors_provider.dart';

class MedicalRecordEntryDialog extends StatefulWidget {
  final MedicalRecordEntry? entry;
  final int medicalRecordId;

  const MedicalRecordEntryDialog({
    super.key,
    this.entry,
    required this.medicalRecordId,
  });

  @override
  State<MedicalRecordEntryDialog> createState() =>
      _MedicalRecordEntryDialogState();
}

class _MedicalRecordEntryDialogState extends State<MedicalRecordEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  late String? _entryType;
  late String? _title;
  late String? _description;

  static const _entryTypes = [
    DropdownMenuItem(value: "diagnosis", child: Text("Diagnosis")),
    DropdownMenuItem(value: "prescription", child: Text("Prescription")),
    DropdownMenuItem(value: "general", child: Text("General")),
  ];

  @override
  void initState() {
    super.initState();
    _entryType = widget.entry?.entryType?.toLowerCase();
    if (_entryType != null &&
        !["diagnosis", "prescription", "general"].contains(_entryType)) {
      _entryType = null;
    }
    _title = widget.entry?.title;
    _description = widget.entry?.description;
  }

  Future<int> _getDoctorIdForCurrentUser() async {
    final doctorProvider = DoctorsProvider();
    final result = await doctorProvider.get(
      filter: {"UserId": AuthProvider.userId},
      retrieveAll: true,
    );
    if (result.resultList.isEmpty) {
      throw Exception("Doctor not found for this user!");
    }
    return result.resultList.first.doctorId!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.entry == null ? "Add Entry" : "Edit Entry"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _entryType,
                items: _entryTypes,
                onChanged: (v) => setState(() => _entryType = v),
                decoration: const InputDecoration(labelText: "Type"),
                validator:
                    (v) => v == null || v.isEmpty ? "Type is required" : null,
              ),
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: "Title"),
                validator:
                    (v) => v == null || v.isEmpty ? "Title required" : null,
                onChanged: (v) => _title = v,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                onChanged: (v) => _description = v,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final doctorId = await _getDoctorIdForCurrentUser();

              final entry =
                  MedicalRecordEntry()
                    ..medicalRecordId = widget.medicalRecordId
                    ..doctorId = doctorId
                    ..entryType = _entryType?.toLowerCase()
                    ..entryDate = DateTime.now().toIso8601String()
                    ..title = _title
                    ..description = _description;

              if (widget.entry != null) {
                entry.medicalRecordEntryId = widget.entry!.medicalRecordEntryId;
              }
              Navigator.of(context).pop(entry);
            }
          },
          child: Text(widget.entry == null ? "Add" : "Save"),
        ),
      ],
    );
  }
}

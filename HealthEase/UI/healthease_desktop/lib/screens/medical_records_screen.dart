import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/medical_record.dart';
import 'package:healthease_desktop/models/medical_record_entry.dart';
import 'package:healthease_desktop/providers/medical_records_provider.dart';
import 'package:healthease_desktop/providers/medical_record_entries_provider.dart';
import 'package:healthease_desktop/providers/patients_provider.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/providers/doctors_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:healthease_desktop/screens/widgets/medical_record_entry_dialog.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final _medicalRecordsProvider = MedicalRecordsProvider();
  final _entriesProvider = MedicalRecordEntriesProvider();
  final _patientsProvider = PatientsProvider();
  final TextEditingController _searchController = TextEditingController();

  List<MedicalRecord> _records = [];
  Map<int, String> _patientNames = {};
  MedicalRecord? _selectedRecord;
  bool _isLoading = true;
  bool _isPatientsLoading = false;

  String _search = '';
  String _entryTypeFilter = "All"; // Fix: Use "All" as default, never null.

  Timer? _debounce;

  int? _currentDoctorId;
  bool _isDoctorIdLoading = false;

  bool get isAdmin =>
      AuthProvider.userRoles?.any(
        (role) => role.role?.roleName?.toLowerCase() == 'admin',
      ) ??
      false;

  bool get isDoctor =>
      AuthProvider.userRoles?.any(
        (role) => role.role?.roleName?.toLowerCase() == 'doctor',
      ) ??
      false;

  @override
  void initState() {
    super.initState();
    _searchController.text = _search;
    _initDoctorIdAndFetch();
  }

  Future<void> _initDoctorIdAndFetch() async {
    if (isDoctor) {
      setState(() => _isDoctorIdLoading = true);
      try {
        final doctorsProvider = DoctorsProvider();
        final result = await doctorsProvider.get(
          filter: {"UserId": AuthProvider.userId},
          retrieveAll: true,
        );
        if (result.resultList.isNotEmpty) {
          _currentDoctorId = result.resultList.first.doctorId;
        }
      } catch (_) {
        _currentDoctorId = null;
      } finally {
        if (mounted) setState(() => _isDoctorIdLoading = false);
      }
    }
    await _fetchRecords();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecords({int? selectedMedicalRecordId}) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      var result = await _medicalRecordsProvider.get(
        filter: {'PatientName': _search},
        retrieveAll: true,
        includeTables: 'Entries',
      );
      _records = result.resultList;

      final patientIds =
          _records.map((r) => r.patientId).whereType<int>().toSet();

      setState(() => _isPatientsLoading = true);

      Map<int, String> names = {};
      for (final pid in patientIds) {
        try {
          final p = await _patientsProvider.getById(pid);
          names[pid] =
              "${p.firstName ?? ''} ${p.lastName ?? ''}".trim().isNotEmpty
                  ? "${p.firstName ?? ''} ${p.lastName ?? ''}".trim()
                  : "Unknown";
        } catch (_) {
          names[pid] = "Unknown";
        }
      }

      setState(() {
        _patientNames = names;
        if (selectedMedicalRecordId != null) {
          if (_records.isNotEmpty) {
            _selectedRecord = _records.firstWhere(
              (r) => r.medicalRecordId == selectedMedicalRecordId,
              orElse: () => _records.first,
            );
          } else {
            _selectedRecord = null;
          }
        } else {
          if (_selectedRecord != null &&
              !_records.any(
                (r) => r.medicalRecordId == _selectedRecord!.medicalRecordId,
              )) {
            _selectedRecord = null;
          }
        }
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPatientsLoading = false;
        });
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  Future<void> _openEntryDialog({
    MedicalRecordEntry? entry,
    required int recordId,
  }) async {
    final isEdit = entry != null;
    if (isDoctor &&
        _currentDoctorId != null &&
        (!isEdit || entry!.doctorId == _currentDoctorId)) {
      final result = await showDialog<MedicalRecordEntry>(
        context: context,
        builder:
            (ctx) => MedicalRecordEntryDialog(
              entry: entry,
              medicalRecordId: recordId,
            ),
      );
      if (result != null) {
        try {
          if (isEdit) {
            await _entriesProvider.update(
              entry!.medicalRecordEntryId!,
              result.toJson(),
            );
            await showSuccessAlert(context, "Entry updated!");
          } else {
            await _entriesProvider.insert(result.toJson());
            await showSuccessAlert(context, "Entry added!");
          }
          await _fetchRecords(selectedMedicalRecordId: recordId);
        } catch (e) {
          await showErrorAlert(context, "Failed to save entry!");
        }
      }
    }
  }

  Future<void> _deleteEntry(MedicalRecordEntry entry) async {
    if (isDoctor &&
        _currentDoctorId != null &&
        entry.doctorId == _currentDoctorId) {
      await _entriesProvider.delete(entry.medicalRecordEntryId!);
      _fetchRecords();
    }
  }

  Widget _buildAvatar(String? name) {
    String initials = "";
    if (name != null && name.trim().isNotEmpty) {
      var parts = name.trim().split(" ");
      if (parts.length == 1) {
        initials = parts[0][0].toUpperCase();
      } else {
        initials = "${parts[0][0]}${parts[1][0]}".toUpperCase();
      }
    }
    return CircleAvatar(
      radius: 19,
      backgroundColor: const Color(0xFF1565C0),
      child: Text(initials, style: const TextStyle(color: Colors.white)),
    );
  }

  List<String> get _uniqueEntryTypes {
    final entries = _selectedRecord?.entries;
    if (entries == null) return [];
    return entries
        .map((e) => e.entryType)
        .whereType<String>()
        .toSet()
        .where((type) => type.trim().isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isDoctorIdLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      children: [
        // Sidebar: Patient list & search
        Container(
          width: 340,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border(
              right: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: "Search patient",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) {
                    setState(() => _search = v);
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 350), () {
                      _fetchRecords();
                    });
                  },
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child:
                    _isPatientsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          itemCount: _records.length,
                          itemBuilder: (ctx, idx) {
                            final record = _records[idx];
                            final selected =
                                _selectedRecord?.medicalRecordId ==
                                record.medicalRecordId;
                            final displayName =
                                _patientNames[record.patientId] ??
                                "Patient ID: ${record.patientId}";
                            return Card(
                              color:
                                  selected
                                      ? Colors.blue.shade100
                                      : Colors.white,
                              elevation: selected ? 4 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side:
                                    selected
                                        ? const BorderSide(
                                          color: Colors.blue,
                                          width: 2,
                                        )
                                        : BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 11,
                              ),
                              child: ListTile(
                                leading: _buildAvatar(displayName),
                                title: Text(
                                  displayName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        selected
                                            ? Colors.blue[900]
                                            : Colors.black87,
                                  ),
                                ),
                                subtitle:
                                    record.notes != null &&
                                            record.notes!.isNotEmpty
                                        ? Text(
                                          record.notes!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                        : null,
                                onTap:
                                    () => setState(() {
                                      _selectedRecord = record;
                                      _entryTypeFilter = "All";
                                    }),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
        // Main panel: Medical record entries
        Expanded(
          child:
              _selectedRecord == null
                  ? const Center(
                    child: Text(
                      "Select a patient to view medical record",
                      style: TextStyle(fontSize: 19, color: Colors.black54),
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Medical Record Entries",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            // Filter dropdown: ALWAYS safe now!
                            DropdownButton<String>(
                              value: _entryTypeFilter,
                              items: [
                                const DropdownMenuItem(
                                  value: "All",
                                  child: Text("All"),
                                ),
                                ..._uniqueEntryTypes.map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _entryTypeFilter = v);
                                }
                              },
                            ),
                            const Spacer(),
                            if (isDoctor)
                              ElevatedButton.icon(
                                onPressed:
                                    () => _openEntryDialog(
                                      recordId:
                                          _selectedRecord!.medicalRecordId!,
                                    ),
                                icon: const Icon(Icons.add),
                                label: const Text("Add Entry"),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child:
                              (_selectedRecord!.entries ?? []).isEmpty
                                  ? Center(
                                    child: Text(
                                      "No entries for this patient.",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  )
                                  : SizedBox(
                                    width: 950,
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: DataTable(
                                          columnSpacing: 16,
                                          border: TableBorder.symmetric(
                                            inside: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                          columns: const [
                                            DataColumn(label: Text("Type")),
                                            DataColumn(label: Text("Date")),
                                            DataColumn(label: Text("Title")),
                                            DataColumn(
                                              label: Text("Description"),
                                            ),
                                            DataColumn(label: Text("Actions")),
                                          ],
                                          rows:
                                              (_selectedRecord!.entries ?? [])
                                                  .where(
                                                    (e) =>
                                                        _entryTypeFilter ==
                                                            "All" ||
                                                        e.entryType ==
                                                            _entryTypeFilter,
                                                  )
                                                  .map((entry) {
                                                    final canEdit =
                                                        isDoctor &&
                                                        _currentDoctorId !=
                                                            null &&
                                                        entry.doctorId ==
                                                            _currentDoctorId;
                                                    return DataRow(
                                                      cells: [
                                                        DataCell(
                                                          Text(
                                                            entry.entryType ??
                                                                "",
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            formatDateString(
                                                              entry.entryDate,
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            entry.title ?? "",
                                                          ),
                                                        ),
                                                        DataCell(
                                                          SizedBox(
                                                            width: 210,
                                                            child: Text(
                                                              entry.description ??
                                                                  "",
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Row(
                                                            children: [
                                                              if (canEdit)
                                                                IconButton(
                                                                  icon: const Icon(
                                                                    Icons.edit,
                                                                    size: 18,
                                                                  ),
                                                                  tooltip:
                                                                      "Edit entry",
                                                                  onPressed:
                                                                      () => _openEntryDialog(
                                                                        entry:
                                                                            entry,
                                                                        recordId:
                                                                            _selectedRecord!.medicalRecordId!,
                                                                      ),
                                                                ),
                                                              if (canEdit)
                                                                IconButton(
                                                                  icon: const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 18,
                                                                  ),
                                                                  tooltip:
                                                                      "Delete entry",
                                                                  onPressed: () async {
                                                                    final confirmed = await showCustomConfirmDialog(
                                                                      context,
                                                                      title:
                                                                          "Confirm Delete",
                                                                      text:
                                                                          "Are you sure you want to delete this entry?",
                                                                      confirmBtnText:
                                                                          "Delete",
                                                                      confirmBtnColor:
                                                                          Colors
                                                                              .red,
                                                                    );
                                                                    if (confirmed) {
                                                                      try {
                                                                        await _deleteEntry(
                                                                          entry,
                                                                        );
                                                                        await showSuccessAlert(
                                                                          context,
                                                                          "Entry deleted!",
                                                                        );
                                                                        await _fetchRecords(
                                                                          selectedMedicalRecordId:
                                                                              _selectedRecord?.medicalRecordId,
                                                                        );
                                                                      } catch (
                                                                        e
                                                                      ) {
                                                                        await showErrorAlert(
                                                                          context,
                                                                          "Failed to delete entry!",
                                                                        );
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  })
                                                  .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }
}

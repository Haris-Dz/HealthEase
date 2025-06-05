import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/medical_records_provider.dart';
import 'package:healthease_mobile/models/medical_record.dart';
import 'package:healthease_mobile/models/medical_record_entry.dart';
import 'package:healthease_mobile/providers/utils.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  MedicalRecord? _medicalRecord;
  bool _isLoading = true;

  // FILTERS:
  String _searchQuery = "";
  String _selectedType = "All";
  bool _sortNewestFirst = true;

  List<String> get _entryTypes => [
    "All",
    ...?_medicalRecord?.entries
        ?.map((e) => (e.entryType ?? "").capitalize())
        .toSet(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchMedicalRecord();
  }

  Future<void> _fetchMedicalRecord() async {
    setState(() => _isLoading = true);
    try {
      final provider = MedicalRecordsProvider();
      final res = await provider.get(
        filter: {"PatientId": AuthProvider.patientId},
        retrieveAll: true,
        includeTables: "Entries",
      );
      if (res.resultList.isNotEmpty) {
        setState(() {
          _medicalRecord = res.resultList.first;
        });
      }
    } catch (e) {
      await showErrorAlert(context, "Failed to load medical record.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<MedicalRecordEntry> _filteredEntries() {
    if (_medicalRecord?.entries == null) return [];
    var entries = List<MedicalRecordEntry>.from(_medicalRecord!.entries!);

    // Type filter
    if (_selectedType != "All") {
      entries =
          entries
              .where(
                (e) =>
                    (e.entryType ?? "").toLowerCase() ==
                    _selectedType.toLowerCase(),
              )
              .toList();
    }

    // Search
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      entries =
          entries
              .where(
                (e) =>
                    (e.title ?? '').toLowerCase().contains(q) ||
                    (e.description ?? '').toLowerCase().contains(q),
              )
              .toList();
    }

    // Sort
    entries.sort((a, b) {
      final adate = DateTime.tryParse(a.entryDate ?? "") ?? DateTime(2000);
      final bdate = DateTime.tryParse(b.entryDate ?? "") ?? DateTime(2000);
      return _sortNewestFirst ? bdate.compareTo(adate) : adate.compareTo(bdate);
    });

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Medical Record",
      currentRoute: "Medical Record",
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _medicalRecord == null
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_information_rounded, size: 72),
                    SizedBox(height: 16),
                    Text(
                      "No medical records found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _fetchMedicalRecord,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Info o kartonu
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "General Info",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Notes: ${_medicalRecord!.notes?.isNotEmpty == true ? _medicalRecord!.notes : 'No notes.'}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // FILTERS
                    Card(
                      margin: const EdgeInsets.only(bottom: 18),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          // OVDJE UMJESTO Row
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                hintText: "Search by title/description...",
                                prefixIcon: Icon(Icons.search),
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged:
                                  (v) => setState(() => _searchQuery = v),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedType,
                              items:
                                  _entryTypes.map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type.capitalize()),
                                    );
                                  }).toList(),
                              decoration: const InputDecoration(
                                labelText: "Type",
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              onChanged:
                                  (val) => setState(() {
                                    _selectedType = val ?? "All";
                                  }),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  tooltip: "Toggle sort",
                                  onPressed:
                                      () => setState(() {
                                        _sortNewestFirst = !_sortNewestFirst;
                                      }),
                                  icon: Icon(
                                    _sortNewestFirst
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Text(
                      "Entries",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_filteredEntries().isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text("No entries.")),
                      )
                    else
                      ..._filteredEntries()
                          .map((entry) => _buildEntryCard(entry))
                          .toList(),
                  ],
                ),
              ),
    );
  }

  Widget _buildEntryCard(MedicalRecordEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: _buildEntryIcon(entry.entryType ?? ""),
        title: Text(
          entry.title ?? "Untitled",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.entryType != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Text(
                  entry.entryType!.capitalize(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            if (entry.description != null && entry.description!.isNotEmpty)
              Text(entry.description!),
            if (entry.entryDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(entry.entryDate),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryIcon(String entryType) {
    switch (entryType.toLowerCase()) {
      case "diagnosis":
        return const Icon(
          Icons.coronavirus_outlined,
          color: Colors.orange,
          size: 32,
        );
      case "prescription":
        return const Icon(
          Icons.medical_services,
          color: Colors.green,
          size: 32,
        );
      case "general":
        return const Icon(Icons.notes, color: Colors.blue, size: 32);
      default:
        return const Icon(Icons.info_outline, color: Colors.grey, size: 32);
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}.";
    } catch (_) {
      return dateStr;
    }
  }
}

// Helper za capitalize (možeš i negdje globalno):
extension StringCap on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

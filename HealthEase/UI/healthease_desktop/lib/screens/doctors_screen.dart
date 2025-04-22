import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthease_desktop/models/doctor.dart';
import 'package:healthease_desktop/providers/doctors_provider.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    final response = await Provider.of<DoctorsProvider>(context, listen: false).get();
    setState(() {
      _doctors = response.resultList;
      _filteredDoctors = _doctors;
      _isLoading = false;
    });
  }

  void _filterDoctors(String query) {
    setState(() {
      _filteredDoctors = _doctors.where((doc) {
        final name = "${doc.user?.firstName ?? ''} ${doc.user?.lastName ?? ''}".toLowerCase();
        final bio = doc.biography?.toLowerCase() ?? '';
        final title = doc.title?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
               bio.contains(query.toLowerCase()) ||
               title.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showAddDoctorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Doctor"),
        content: const Text("Add doctor form will go here."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  Color _getStateColor(String? state) {
    switch (state?.toLowerCase()) {
      case "draft": return Colors.orange;
      case "active": return Colors.green;
      case "hidden": return Colors.grey;
      default: return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search + Add Doctor Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterDoctors,
                  decoration: InputDecoration(
                    hintText: "Search doctors...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _showAddDoctorDialog,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Doctor"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white, // ← Ovdje postavljaš boju teksta
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  textStyle: const TextStyle(color: Colors.white), // (opcionalno dodatno osiguranje)
                ),
              )
            ],
          ),
        ),

        // Doctor Cards Grid or Loader
        _isLoading
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 3,
                    ),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      final fullName = "${doctor.user?.firstName ?? ''} ${doctor.user?.lastName ?? ''}".trim();

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade300,
                                      child: (doctor.profilePicture != null && doctor.profilePicture != "AA==")
                                          ? Image.memory(
                                              base64Decode(doctor.profilePicture!),
                                              fit: BoxFit.cover,
                                              width: 60,
                                              height: 60,
                                            )
                                          : Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover,
                                              width: 60,
                                              height: 60,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fullName.isEmpty ? "Unknown Doctor" : fullName,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            (doctor.title?.trim().isEmpty ?? true) ? "N/A" : doctor.title!,
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStateColor(doctor.stateMachine),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  doctor.stateMachine?.toUpperCase() ?? "UNKNOWN",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
      ],
    );
  }
}

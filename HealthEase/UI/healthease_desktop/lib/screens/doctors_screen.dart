import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/screens/widgets/add_doctor_dialog.dart';
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

  void _openAddDoctorDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const AddDoctorDialog(),
    );

    if (result == true) {
      await _loadDoctors();
    }
  }

  Color _getStateColor(String? state) {
    switch (state?.toLowerCase()) {
      case "draft": return Colors.orange;
      case "active": return Colors.green;
      case "hidden": return Colors.grey;
      default: return Colors.blueGrey;
    }
  }

  List<PopupMenuEntry<String>> _buildPopupItems(String? state) {
    return [
      if (state == 'draft' || state == 'active')
        PopupMenuItem(
          value: 'hide',
          child: Row(
            children: const [
              Icon(Icons.visibility_off, color: Colors.grey),
              SizedBox(width: 8),
              Text('Hide')
            ],
          ),
        ),
      if (state == 'draft') ...[
        PopupMenuItem(
          value: 'activate',
          child: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Activate')
            ],
          ),
        ),
        PopupMenuItem(
          value: 'update',
          child: Row(
            children: const [
              Icon(Icons.edit, color: Colors.orange),
              SizedBox(width: 8),
              Text('Update')
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete')
            ],
          ),
        ),
      ],
if (state == 'hidden')
  PopupMenuItem(
    value: 'restore',
      child: Row(
        children: const [
          Icon(Icons.restore, color: Colors.blue),
          SizedBox(width: 8),
          Text('Restore'),
        ],
      ),
  ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                onPressed: _openAddDoctorDialog,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Doctor"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              )
            ],
          ),
        ),
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
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      final fullName = "${doctor.user?.firstName ?? ''} ${doctor.user?.lastName ?? ''}".trim();
                      final state = doctor.stateMachine?.toLowerCase();

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                fullName.isEmpty ? "Unknown Doctor" : fullName,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                (doctor.title?.trim().isEmpty ?? true) ? "N/A" : doctor.title!,
                                                style: const TextStyle(color: Colors.grey),
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuButton<String>(
                                        onSelected: (value) {
                                          // Handle actions
                                        },
                                        itemBuilder: (context) => _buildPopupItems(state),
                                        icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.grey),

                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
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
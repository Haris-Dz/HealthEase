import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:healthease_desktop/screens/widgets/add_doctor_dialog.dart';
import 'package:healthease_desktop/screens/widgets/edit_doctor_dialog.dart';
import 'package:provider/provider.dart';
import 'package:healthease_desktop/models/doctor.dart';
import 'package:healthease_desktop/providers/doctors_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
  late DoctorsProvider _doctorsProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _doctorsProvider = Provider.of<DoctorsProvider>(context, listen: false);
      _loadDoctors();
    }
  }

  Future<void> _loadDoctors() async {
    final response = await _doctorsProvider.get();
    if (!mounted) return;
    setState(() {
      _doctors = response.resultList;
      _filteredDoctors = _doctors;
      _isLoading = false;
    });
  }

  void _filterDoctors(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredDoctors = _doctors.where((doc) {
        final name = "${doc.user?.firstName ?? ''} ${doc.user?.lastName ?? ''}".toLowerCase();
        final bio = doc.biography?.toLowerCase() ?? '';
        final title = doc.title?.toLowerCase() ?? '';
        return name.contains(lowerQuery) || bio.contains(lowerQuery) || title.contains(lowerQuery);
      }).toList();
    });
  }

  Future<void> _handlePopupAction(String action, Doctor doctor) async {
    try {
      switch (action) {
        case 'hide':
          await _doctorsProvider.ChangeState(doctor.doctorId!, "hide");
          await _loadDoctors();
          if (mounted) await showSuccessAlert(context, "Doctor successfully hidden!");
          break;
        case 'activate':
          await _doctorsProvider.ChangeState(doctor.doctorId!, "activate");
          await _loadDoctors();
          if (mounted) await showSuccessAlert(context, "Doctor successfully activated!");
          break;
        case 'restore':
          await _doctorsProvider.ChangeState(doctor.doctorId!, "edit");
          await _loadDoctors();
          if (mounted) await showSuccessAlert(context, "Doctor successfully restored!");
          break;
        case 'delete':
          final confirmed = await showCustomConfirmDialog(
            context,
            title: "Are you sure?",
            text: "Do you want to delete this doctor?",
          );
          if (confirmed) {
            await _doctorsProvider.delete(doctor.doctorId!);
            await _loadDoctors();
            if (mounted) await showSuccessAlert(context, "Doctor successfully deleted!");
          }
          break;
        case 'update':
          final result = await showDialog(
            context: context,
            builder: (context) => EditDoctorDialog(
              initialTitle: doctor.title,
              initialBio: doctor.biography,
              initialProfilePicture: doctor.profilePicture,
            ),
          );

          if (result != null && mounted) {
            try {
              await _doctorsProvider.update(doctor.doctorId!, result);
              await _loadDoctors();
              await showSuccessAlert(context, "Doctor updated successfully!");
            } catch (e) {
              await showErrorAlert(context, "Update failed: $e");
            }
          }
          break;

      }
    } catch (e) {
      if (mounted) {
        await showErrorAlert(context, "Action failed: $e");
      }
    }
  }

  List<PopupMenuEntry<String>> _buildPopupItems(String? state) {
    return [
      if (state == 'draft' || state == 'active')
        _popupItem('hide', Icons.visibility_off, Colors.grey, 'Hide'),
      if (state == 'draft') ...[
        _popupItem('activate', Icons.check_circle, Colors.green, 'Activate'),
        _popupItem('update', Icons.edit, Colors.orange, 'Update'),
        _popupItem('delete', Icons.delete, Colors.red, 'Delete'),
      ],
      if (state == 'hidden')
        _popupItem('restore', Icons.restore, Colors.blue, 'Restore'),
    ];
  }

  PopupMenuItem<String> _popupItem(String value, IconData icon, Color color, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Color _getStateColor(String? state) {
    switch (state?.toLowerCase()) {
      case "draft":
        return Colors.orange;
      case "active":
        return Colors.green;
      case "hidden":
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _isLoading
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : Expanded(child: _buildDoctorGrid()),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
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
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorGrid() {
    return Padding(
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
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: (doctor.profilePicture != null && doctor.profilePicture != "AA==")
                          ? Image.memory(base64Decode(doctor.profilePicture!), fit: BoxFit.cover)
                          : Container(
                              color: Colors.grey.shade100,
                              child: const Icon(Icons.person, size: 40, color: Colors.grey),
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
                            onSelected: (value) => _handlePopupAction(value, doctor),
                            itemBuilder: (context) => _buildPopupItems(state),
                            icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

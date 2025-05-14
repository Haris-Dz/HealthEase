import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:healthease_desktop/screens/widgets/add_doctor_dialog.dart';
import 'package:healthease_desktop/screens/widgets/edit_doctor_dialog.dart';
import 'package:healthease_desktop/screens/widgets/edit_working_hours_dialog.dart';
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
      _filteredDoctors =
          _doctors.where((doc) {
            final name =
                "${doc.user?.firstName ?? ''} ${doc.user?.lastName ?? ''}"
                    .toLowerCase();
            final bio = doc.biography?.toLowerCase() ?? '';
            final title = doc.title?.toLowerCase() ?? '';
            return name.contains(lowerQuery) ||
                bio.contains(lowerQuery) ||
                title.contains(lowerQuery);
          }).toList();
    });
  }

  Future<void> _handlePopupAction(String action, Doctor doctor) async {
    try {
      switch (action) {
        case 'hide':
          await _doctorsProvider.ChangeState(doctor.doctorId!, "hide");
          if (!mounted) return;
          await _loadDoctors();
          if (!mounted) return;
          await showSuccessAlert(context, "Doctor successfully hidden!");
          break;

        case 'activate':
          await _doctorsProvider.ChangeState(doctor.doctorId!, "activate");
          if (!mounted) return;
          await _loadDoctors();
          if (!mounted) return;
          await showSuccessAlert(context, "Doctor successfully activated!");
          break;

        case 'restore':
          await _doctorsProvider.ChangeState(doctor.doctorId!, "edit");
          if (!mounted) return;
          await _loadDoctors();
          if (!mounted) return;
          await showSuccessAlert(context, "Doctor successfully restored!");
          break;
        case 'working_hours':
          final result = await showDialog(
            context: context,
            builder:
                (context) => EditWorkingHoursDialog(userId: doctor.userId!),
          );
          if (result == true) {
            await showSuccessAlert(context, "Working hours updated.");
          }
          break;

        case 'delete':
          final confirmed = await showCustomConfirmDialog(
            context,
            title: "Are you sure?",
            text: "Do you want to delete this doctor?",
          );
          if (!mounted) return;
          if (confirmed) {
            await _doctorsProvider.delete(doctor.doctorId!);
            if (!mounted) return;
            await _loadDoctors();
            if (!mounted) return;
            await showSuccessAlert(context, "Doctor successfully deleted!");
          }
          break;

        case 'update':
          final result = await showDialog(
            context: context,
            builder:
                (context) => EditDoctorDialog(
                  initialTitle: doctor.title,
                  initialBio: doctor.biography,
                ),
          );
          if (!mounted) return;

          if (result != null) {
            try {
              await _doctorsProvider.update(doctor.doctorId!, result);
              if (!mounted) return;
              await _loadDoctors();
              if (!mounted) return;
              await showSuccessAlert(context, "Doctor updated successfully!");
            } catch (e) {
              if (!mounted) return;
              await showErrorAlert(context, "Update failed: $e");
            }
          }
          break;
      }
    } catch (e) {
      if (!mounted) return;
      await showErrorAlert(context, "Action failed: $e");
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
        _popupItem(
          'working_hours',
          Icons.schedule,
          Colors.indigo,
          'Edit Working Hours',
        ),
      ],
      if (state == 'hidden')
        _popupItem('restore', Icons.restore, Colors.blue, 'Restore'),
    ];
  }

  PopupMenuItem<String> _popupItem(
    String value,
    IconData icon,
    Color color,
    String text,
  ) {
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
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2.3,
            ),
            itemCount: _filteredDoctors.length,
            itemBuilder: (context, index) {
              final doctor = _filteredDoctors[index];
              final fullName =
                  "${doctor.user?.firstName ?? ''} ${doctor.user?.lastName ?? ''}"
                      .trim();
              final state = doctor.stateMachine?.toLowerCase();

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                        (doctor.user?.profilePicture != null &&
                                                doctor.user!.profilePicture !=
                                                    "AA==")
                                            ? Image.memory(
                                              base64Decode(
                                                doctor.user!.profilePicture!,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                            : Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fullName.isEmpty
                                            ? "Unknown Doctor"
                                            : fullName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        (doctor.title?.trim().isEmpty ?? true)
                                            ? "N/A"
                                            : doctor.title!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStateColor(
                                            doctor.stateMachine,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          doctor.stateMachine?.toUpperCase() ??
                                              "UNKNOWN",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (doctor.biography != null &&
                                doctor.biography!.trim().isNotEmpty) ...[
                              const Text(
                                "Biography",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                doctor.biography!,
                                style: const TextStyle(fontSize: 13),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 40), // prostor za meni
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: PopupMenuButton<String>(
                        onSelected:
                            (value) => _handlePopupAction(value, doctor),
                        itemBuilder: (context) => _buildPopupItems(state),
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

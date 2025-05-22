import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/models/specialization.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/doctors_provider.dart';
import 'package:healthease_mobile/providers/patient_doctor_favorites_provider.dart';
import 'package:healthease_mobile/providers/specializations_provider.dart';
import 'package:healthease_mobile/screens/doctor_details_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  List<Doctor> _doctors = [];
  List<Doctor> _recommendedDoctors = [];
  List<Specialization> _specializations = [];
  List<int> _selectedSpecializationIds = [];
  List<int> _favoriteDoctorIds = [];
  bool _isLoading = true;
  String _searchName = '';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _fetchFilters();
    await _fetchFavorites();
    await _fetchDoctors();
    await _fetchRecommended();
  }

  Future<void> _fetchFilters() async {
    final specProvider = Provider.of<SpecializationsProvider>(
      context,
      listen: false,
    );
    final specs = await specProvider.get();
    _specializations = specs.resultList;
  }

  Future<void> _fetchFavorites() async {
    final favProvider = Provider.of<PatientDoctorFavoritesProvider>(
      context,
      listen: false,
    );
    final favorites = await favProvider.getByPatientId(AuthProvider.patientId!);
    if (!mounted) return;
    setState(() {
      _favoriteDoctorIds = favorites.map((f) => f.doctorId!).toList();
    });
  }

  Future<void> _fetchDoctors() async {
    final provider = Provider.of<DoctorsProvider>(context, listen: false);
    final filter = {
      if (_searchName.isNotEmpty) 'FirstLastNameGTE': _searchName,
      if (_selectedSpecializationIds.isNotEmpty)
        'SpecializationIds': _selectedSpecializationIds,
    };
    final result = await provider.get(
      includeTables: "User,DoctorSpecializations,User.WorkingHours",
      filter: filter,
    );
    if (!mounted) return;
    setState(() {
      _doctors =
          result.resultList
              .where((doc) => doc.stateMachine?.toLowerCase() == "active")
              .toList();
      _isLoading = false;
    });
  }

  Future<void> _fetchRecommended() async {
    final provider = Provider.of<DoctorsProvider>(context, listen: false);
    final recommended = await provider.getRecommended();
    if (!mounted) return;
    setState(() {
      _recommendedDoctors = recommended;
    });
  }

  Future<void> _toggleFavorite(int doctorId) async {
    final favProvider = Provider.of<PatientDoctorFavoritesProvider>(
      context,
      listen: false,
    );
    await favProvider.toggleFavorite(AuthProvider.patientId!, doctorId);
    if (!mounted) return;
    setState(() {
      if (_favoriteDoctorIds.contains(doctorId)) {
        _favoriteDoctorIds.remove(doctorId);
      } else {
        _favoriteDoctorIds.add(doctorId);
      }
    });
  }

  bool _isRecommended(int doctorId) {
    return _recommendedDoctors.any((doc) => doc.doctorId == doctorId);
  }

  Widget _buildDoctorCard(Doctor doctor) {
    Uint8List? imageBytes;
    if (doctor.user?.profilePicture != null &&
        doctor.user?.profilePicture != "AA==") {
      imageBytes = base64Decode(doctor.user!.profilePicture!);
    }

    final workingHours = doctor.workingHours;
    String workingText =
        workingHours != null && workingHours.isNotEmpty
            ? "${workingHours.first.startTime} - ${workingHours.first.endTime}"
            : "";

    final isFavorite = _favoriteDoctorIds.contains(doctor.doctorId);
    final isRecommended = _isRecommended(doctor.doctorId!);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isRecommended ? const Color(0xFFB3E5FC) : const Color(0xFFDCE7FF),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  imageBytes != null
                      ? MemoryImage(imageBytes)
                      : const AssetImage('assets/images/placeholder.png')
                          as ImageProvider,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Dr. ${doctor.user?.firstName ?? ''} ${doctor.user?.lastName ?? ''}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (isRecommended)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Recommended",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.doctorSpecializations
                            ?.where((s) => s.name != null)
                            .map((s) => s.name!)
                            .join(", ") ??
                        "-",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workingText,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      DoctorDetailsScreen(doctor: doctor),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Details"),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: () => _toggleFavorite(doctor.doctorId!),
                        tooltip: "Favorite",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSpecializationFilterDialog() async {
    final selected = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        List<int> tempSelection = List<int>.from(_selectedSpecializationIds);

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Specializations"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CheckboxListTile(
                      title: const Text("All"),
                      value: tempSelection.length == _specializations.length,
                      onChanged: (value) {
                        setStateDialog(() {
                          tempSelection =
                              value == true
                                  ? _specializations
                                      .map((e) => e.specializationId!)
                                      .toList()
                                  : [];
                        });
                      },
                    ),
                    ..._specializations.map(
                      (s) => CheckboxListTile(
                        title: Text(s.name ?? ''),
                        value: tempSelection.contains(s.specializationId),
                        onChanged: (val) {
                          setStateDialog(() {
                            if (val == true) {
                              tempSelection.add(s.specializationId!);
                            } else {
                              tempSelection.remove(s.specializationId!);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, tempSelection),
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() => _selectedSpecializationIds = selected);
      _fetchDoctors();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kombinuj doktore, preporučene idu na vrh, ostali ispod
    final Set<int> recommendedIds =
        _recommendedDoctors.map((d) => d.doctorId!).toSet();
    final List<Doctor> sortedDoctors = [
      ..._recommendedDoctors,
      ..._doctors.where((d) => !recommendedIds.contains(d.doctorId)),
    ];

    return MasterScreen(
      title: "Doctors",
      currentRoute: "Doctors",
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "Search by name",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                setState(() => _searchName = value);
                                _fetchDoctors();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _openSpecializationFilterDialog,
                          icon: const Icon(Icons.filter_list),
                          tooltip: "Filter",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: sortedDoctors.length,
                        itemBuilder:
                            (context, index) =>
                                _buildDoctorCard(sortedDoctors[index]),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

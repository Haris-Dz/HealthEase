import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:healthease_mobile/screens/doctors_screen.dart';
import 'package:provider/provider.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/doctors_provider.dart';
import 'package:healthease_mobile/providers/patient_doctor_favorites_provider.dart';
import 'package:healthease_mobile/screens/doctor_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Doctor> _favoriteDoctors = [];
  List<int> _favoriteDoctorIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final favProvider = Provider.of<PatientDoctorFavoritesProvider>(
      context,
      listen: false,
    );
    final doctorProvider = Provider.of<DoctorsProvider>(context, listen: false);

    final favorites = await favProvider.getByPatientId(AuthProvider.patientId!);
    if (!mounted) return;
    _favoriteDoctorIds = favorites.map((f) => f.doctorId!).toList();

    if (_favoriteDoctorIds.isEmpty) {
      if (!mounted) return;
      setState(() {
        _favoriteDoctors = [];
        _isLoading = false;
      });
      return;
    }

    final allDoctors = await doctorProvider.get(
      retrieveAll: true,
      includeTables: "User,DoctorSpecializations,User.WorkingHours",
    );
    if (!mounted) return;
    setState(() {
      _favoriteDoctors =
          allDoctors.resultList
              .where(
                (d) =>
                    _favoriteDoctorIds.contains(d.doctorId) &&
                    d.stateMachine?.toLowerCase() == 'active',
              )
              .toList();
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(int doctorId) async {
    final confirmed = await showCustomConfirmDialog(
      context,
      title: "Remove from favorites",
      text: "Are you sure you want to remove this doctor from your favorites?",
      confirmBtnText: "Remove",
      cancelBtnText: "Cancel",
      confirmBtnColor: Colors.red,
      cancelBorderColor: Colors.grey,
    );
    if (!confirmed) return;
    final favProvider = Provider.of<PatientDoctorFavoritesProvider>(
      context,
      listen: false,
    );
    showSuccessAlert(context, "Removed from favorites");
    await favProvider.toggleFavorite(AuthProvider.patientId!, doctorId);
    await _loadFavorites();
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
            ? "Mon-Fri: ${workingHours.first.startTime} - ${workingHours.first.endTime}"
            : "";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFDCE7FF),
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
                  Text(
                    "Dr. ${doctor.user?.firstName ?? ''} ${doctor.user?.lastName ?? ''}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                                  (_) => DoctorDetailsScreen(doctor: doctor),
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
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        tooltip: "Remove from favorites",
                        onPressed: () => _toggleFavorite(doctor.doctorId!),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          const Text(
            "You haven’t added any favorite doctors yet.",
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => DoctorsScreen()));
            },
            icon: const Icon(Icons.search),
            label: const Text("Browse doctors"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Favorite Doctors",
      currentRoute: "Favorites",
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child:
                    _favoriteDoctors.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                          itemCount: _favoriteDoctors.length,
                          itemBuilder:
                              (context, index) =>
                                  _buildDoctorCard(_favoriteDoctors[index]),
                        ),
              ),
    );
  }
}

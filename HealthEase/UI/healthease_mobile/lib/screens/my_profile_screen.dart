import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/patients_provider.dart';
import 'package:healthease_mobile/screens/edit_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Map<String, dynamic>? _patient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    try {
      final provider = Provider.of<PatientProvider>(context, listen: false);
      final result = await provider.getById(AuthProvider.patientId!);
      if (!mounted) return;
      setState(() {
        _patient = result.toJson();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "My Profile",
      currentRoute: "My Profile",
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            (_patient?['profilePicture'] == null ||
                                    _patient!['profilePicture'] == "AA==")
                                ? const AssetImage(
                                      'assets/images/placeholder.png',
                                    )
                                    as ImageProvider
                                : MemoryImage(
                                  base64Decode(_patient!['profilePicture']),
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${_patient?['firstName'] ?? '-'} ${_patient?['lastName'] ?? '-'}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _patient?['email'] ?? '-',
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    const Divider(thickness: 1),
                    _buildInfoRow("Username", _patient?['username'] ?? "-"),
                    _buildInfoRow("Phone", _patient?['phoneNumber'] ?? "-"),
                    _buildInfoRow(
                      "Registered",
                      (_patient?['registrationDate'] as String)
                          .split('T')
                          .first,
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );

                        if (result == true) {
                          await _loadPatient();
                        }
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

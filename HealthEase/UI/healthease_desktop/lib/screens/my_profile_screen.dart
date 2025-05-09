import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/user.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/providers/users_provider.dart';
import 'package:healthease_desktop/screens/widgets/edit_profile_dialog.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late Future<User?> _userFuture;
  bool _disposed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUser();
  }

  void _loadUser() {
    _userFuture = Provider.of<UsersProvider>(
      context,
      listen: false,
    ).getById(AuthProvider.userId!);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE3F2FD),
      padding: const EdgeInsets.all(40),
      child: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Failed to load profile."));
          }

          final user = snapshot.data!;
          Uint8List? imageBytes;
          if (user.profilePicture != null && user.profilePicture != "AA==") {
            imageBytes = base64Decode(user.profilePicture!);
          }

          return Center(
            child: Container(
              width:
                  MediaQuery.of(context).size.width > 1100
                      ? 1000
                      : double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                      image: DecorationImage(
                        image:
                            imageBytes != null
                                ? MemoryImage(imageBytes)
                                : const AssetImage(
                                      'assets/images/placeholder.png',
                                    )
                                    as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(
                          "Full Name",
                          "${user.firstName} ${user.lastName}",
                        ),
                        _infoRow("Username", user.username ?? ""),
                        _infoRow("Email", user.email ?? ""),
                        _infoRow("Phone", user.phoneNumber ?? "-"),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Tooltip(
                            message: "Edit your profile",
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final result = await showDialog(
                                  context: context,
                                  builder:
                                      (context) => const EditProfileDialog(),
                                );

                                if (result != null && mounted && !_disposed) {
                                  final updatedFuture =
                                      Provider.of<UsersProvider>(
                                        context,
                                        listen: false,
                                      ).getById(AuthProvider.userId!);

                                  if (!_disposed) {
                                    setState(() {
                                      _userFuture = updatedFuture;
                                    });
                                  }
                                }
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit Profile"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

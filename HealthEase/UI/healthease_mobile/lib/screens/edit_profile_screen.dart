import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthease_mobile/models/patient.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/patients_provider.dart';
import 'package:provider/provider.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _changePassword = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();



  Uint8List? _selectedImage;
  String? _base64Image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatient();
  }
    @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  Future<void> _loadPatient() async {
    final provider = Provider.of<PatientProvider>(context, listen: false);
    final Patient result = await provider.getById(AuthProvider.patientId!);


    setState(() {
    _firstNameController.text = result.firstName ?? '';
    _lastNameController.text = result.lastName ?? '';
    _phoneController.text = result.phoneNumber ?? '';
    _base64Image = result.profilePicture;

    if (_base64Image != null && _base64Image != "AA==") {
      _selectedImage = base64Decode(_base64Image!);
    }

    _isLoading = false;
  });

  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImage = bytes;
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    final request = {
    "firstName": _firstNameController.text.trim(),
    "lastName": _lastNameController.text.trim(),
    "phoneNumber": _phoneController.text.trim(),
    "profilePicture": _base64Image ?? "AA==",
    "edit": true,
    "isActive": true,
  };

  if (_changePassword) {
    request.addAll({
      "currentPassword": _currentPasswordController.text.trim(),
      "password": _newPasswordController.text.trim(),
      "passwordConfirmation": _confirmPasswordController.text.trim(),
    });
  }
    final provider = Provider.of<PatientProvider>(context, listen: false);

    try {
      await provider.update(AuthProvider.patientId!,request);

      if (mounted) {
      if (_changePassword) {
        AuthProvider.username = null;
        AuthProvider.password = null;
        AuthProvider.userId = null;
        AuthProvider.patientId = null;
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        showSuccessAlert(context, "Password changed. Please login again.");
      } else {
        Navigator.pop(context, true);
        showSuccessAlert(context, "Profile updated successfully");
      }
    }
    } catch (e) {
      
      showErrorAlert(context,"Update failed: current password incorrect");
    }
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 60, // povećan
            backgroundImage: _selectedImage != null
                ? MemoryImage(_selectedImage!)
                : const AssetImage("assets/images/placeholder.png") as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.camera_alt, size: 22, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Edit Profile",
      showBackButton: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: "First Name"),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: "Last Name"),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: "Phone Number"),
                      validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          if (!RegExp(r'^\d{9}$').hasMatch(value)) return "Enter a 9-digit number";
                          return null;
                        },
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      value: _changePassword,
                      onChanged: (value) => setState(() => _changePassword = value!),
                      title: const Text("Change Password"),
                    ),

                    if (_changePassword) ...[
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: _obscureCurrent,
                        decoration: InputDecoration(
                          labelText: "Current Password",
                          suffixIcon: IconButton(
                            icon: Icon(_obscureCurrent ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNew,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          suffixIcon: IconButton(
                            icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscureNew = !_obscureNew),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) return "Minimum 6 characters";
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (value) {
                          if (value != _newPasswordController.text) return "Passwords do not match";
                          return null;
                        },
                      ),
                    ],


                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text("Save Changes"),
                    )
                  ],
                ),
              ),
            ),
            ),
    );
  }
}

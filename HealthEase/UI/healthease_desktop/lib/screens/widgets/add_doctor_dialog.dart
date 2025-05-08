import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/doctors_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddDoctorDialog extends StatefulWidget {
  const AddDoctorDialog({super.key});

  @override
  State<AddDoctorDialog> createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends State<AddDoctorDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController biographyController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  Uint8List? _selectedImage;
  String? _base64Image;

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 500,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Add Doctor",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildImagePicker(),

                      _buildTextField(firstNameController, "First Name"),
                      _buildTextField(lastNameController, "Last Name"),
                      _buildTextField(
                        phoneNumberController,
                        "Phone Number",
                        validator: (value) {
                          final phoneRegex = RegExp(r'^\d{9}$');
                          if (value == null || value.isEmpty) return null;
                          if (!phoneRegex.hasMatch(value))
                            return "Enter valid 9-digit number";
                          return null;
                        },
                      ),
                      _buildTextField(
                        emailController,
                        "Email",
                        validator: (value) {
                          final emailRegex = RegExp(
                            r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                          );
                          if (value == null || value.isEmpty) return "Required";
                          if (!emailRegex.hasMatch(value))
                            return "Invalid email";
                          return null;
                        },
                      ),
                      _buildTextField(usernameController, "Username"),
                      _buildTextField(
                        biographyController,
                        "Biography",
                        maxLines: 3,
                        required: false,
                      ),
                      _buildTextField(
                        titleController,
                        "Title",
                        required: false,
                      ),

                      const SizedBox(height: 30),

                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final imageBytes = await picked.readAsBytes();
      setState(() {
        _selectedImage = imageBytes;
        _base64Image = base64Encode(imageBytes);
      });
    }
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
          image:
              _selectedImage != null
                  ? DecorationImage(
                    image: MemoryImage(_selectedImage!),
                    fit: BoxFit.cover,
                  )
                  : null,
          color: Colors.grey.shade100,
        ),
        child:
            _selectedImage == null
                ? const Center(
                  child: Icon(Icons.add_a_photo, size: 30, color: Colors.grey),
                )
                : null,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines,
        validator:
            validator ??
            (value) =>
                required && (value == null || value.isEmpty)
                    ? "Required"
                    : null,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await Provider.of<DoctorsProvider>(context, listen: false).insert({
        "user": {
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "email": emailController.text,
          "phoneNumber": phoneNumberController.text,
          "username": usernameController.text,
          "roleId": 2,
        },
        "biography": biographyController.text,
        "title": titleController.text,
        "profilePicture": _base64Image ?? "AA==",
      });

      if (context.mounted) {
        Navigator.of(context).pop(true);
        await showSuccessAlert(context, "Doctor added successfully");
      }
    } catch (e) {
      await showErrorAlert(context, "Failed to add doctor: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

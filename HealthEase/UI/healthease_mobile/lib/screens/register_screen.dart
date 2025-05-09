import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healthease_mobile/main.dart';
import 'package:healthease_mobile/providers/patients_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _patientProvider = PatientProvider();
  Uint8List? _imageBytes;
  String? _base64Image;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  _imageBytes != null
                                      ? MemoryImage(_imageBytes!)
                                      : const AssetImage(
                                            'assets/images/placeholder.png',
                                          )
                                          as ImageProvider,
                              child:
                                  _imageBytes == null
                                      ? const Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                        color: Colors.white70,
                                      )
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text("Tap to upload profile picture"),
                          const SizedBox(height: 20),
                        ],
                      ),

                      _buildTextField(
                        controller: _firstNameController,
                        label: "First Name",
                        icon: Icons.person,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Required"
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _lastNameController,
                        label: "Last Name",
                        icon: Icons.person,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Required"
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _emailController,
                        label: "Email",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          final emailRegex = RegExp(
                            r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return "Invalid e-mail (example@mail.com)";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _phoneController,
                        label: "Phone Number (optional)",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final phoneRegex = RegExp(r'^\d{9}$');
                          if (!phoneRegex.hasMatch(value)) {
                            return "Enter 9 digit number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _usernameController,
                        label: "Username",
                        icon: Icons.person_outline,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Required"
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordField(
                        controller: _passwordController,
                        label: "Password",
                        obscure: _obscurePassword,
                        toggle: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: "Confirm Password",
                        obscure: _obscureConfirm,
                        toggle: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33),
                          ),
                        ),
                        child: const Text("Register"),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text("Already have an account? Login"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) return "Required";
            if (value.length < 6) return "Minimum 6 characters";
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Colors.blue),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue,
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final request = {
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "email": _emailController.text.trim(),
          "phoneNumber": _phoneController.text.trim(),
          "username": _usernameController.text.trim(),
          "password": _passwordController.text,
          "passwordConfirmation": _confirmPasswordController.text,
          "profilePicture": _base64Image ?? "",
        };
        await _patientProvider.register(request);
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
        showSuccessAlert(context, "Registration successful");
      } catch (e) {
        if (!mounted) return;
        showErrorAlert(
          context,
          "Failed to register: Username or e-mail already exists.",
        );
      }
    }
  }
}

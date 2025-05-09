import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/providers/users_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:healthease_desktop/models/user.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Uint8List? _selectedImage;
  String? _base64Image;

  bool _changePassword = false;
  bool _isLoading = true;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    final User user = await provider.getById(AuthProvider.userId!);

    setState(() {
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      _base64Image = user.profilePicture;
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = {
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "phoneNumber": _phoneController.text.trim(),
      "profilePicture": _base64Image ?? "AA==",
    };

    if (_changePassword) {
      request.addAll({
        "currentPassword": _currentPasswordController.text.trim(),
        "password": _newPasswordController.text.trim(),
        "passwordConfirmation": _confirmPasswordController.text.trim(),
      });
    }

    final provider = Provider.of<UsersProvider>(context, listen: false);

    try {
      await provider.update(AuthProvider.userId!, request);

      if (mounted) {
        if (_changePassword) {
          AuthProvider.username = null;
          AuthProvider.password = null;
          AuthProvider.userId = null;
          AuthProvider.patientId = null;
          AuthProvider.userRoles = null;
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          showSuccessAlert(context, "Password changed. Please login again.");
        } else {
          Navigator.pop(context, true);
          showSuccessAlert(context, "Profile updated successfully");
        }
      }
    } catch (e) {
      showErrorAlert(context, "Update failed: current password incorrect");
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label),
        validator:
            validator ??
            (value) {
              if (!required) return null;
              return (value == null || value.isEmpty) ? "Required" : null;
            },
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool obscure,
    VoidCallback toggle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
            onPressed: toggle,
          ),
        ),
        validator:
            (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _buildImagePicker() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 50,
          backgroundImage:
              _selectedImage != null
                  ? MemoryImage(_selectedImage!)
                  : const AssetImage("assets/images/placeholder.png")
                      as ImageProvider,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child:
          _isLoading
              ? const SizedBox(
                height: 300,
                width: 300,
                child: Center(child: CircularProgressIndicator()),
              )
              : Container(
                padding: const EdgeInsets.all(24),
                width: 500,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildImagePicker(),
                        const SizedBox(height: 16),
                        _buildTextField(_firstNameController, "First Name"),
                        _buildTextField(_lastNameController, "Last Name"),
                        _buildTextField(
                          _phoneController,
                          "Phone Number",
                          required: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) return null;
                            if (!RegExp(r'^\d{9}$').hasMatch(value)) {
                              return "Must be exactly 9 digits";
                            }
                            return null;
                          },
                        ),
                        CheckboxListTile(
                          title: const Text("Change Password"),
                          value: _changePassword,
                          onChanged:
                              (value) =>
                                  setState(() => _changePassword = value!),
                        ),
                        if (_changePassword) ...[
                          _buildPasswordField(
                            _currentPasswordController,
                            "Current Password",
                            _obscureCurrent,
                            () => setState(
                              () => _obscureCurrent = !_obscureCurrent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TextFormField(
                              controller: _newPasswordController,
                              obscureText: _obscureNew,
                              decoration: InputDecoration(
                                labelText: "New Password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNew
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed:
                                      () => setState(
                                        () => _obscureNew = !_obscureNew,
                                      ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Required";
                                if (value.length < 6)
                                  return "Must be at least 6 characters";
                                return null;
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirm,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed:
                                      () => setState(
                                        () =>
                                            _obscureConfirm = !_obscureConfirm,
                                      ),
                                ),
                              ),
                              validator: (value) {
                                if (value != _newPasswordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                          ),
                          onPressed: _isLoading ? null : _submit,
                          child: const Text("Save Changes"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

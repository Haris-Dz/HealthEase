import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:image_picker/image_picker.dart';

class EditDoctorDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialBio;
  final String? initialProfilePicture; // base64 string

  const EditDoctorDialog({
    super.key,
    this.initialTitle,
    this.initialBio,
    this.initialProfilePicture,
  });

  @override
  State<EditDoctorDialog> createState() => _EditDoctorDialogState();
}

class _EditDoctorDialogState extends State<EditDoctorDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Uint8List? _selectedImage;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _bioController.text = widget.initialBio ?? '';
    if (widget.initialProfilePicture != null && widget.initialProfilePicture != "AA==") {
      _base64Image = widget.initialProfilePicture;
      _selectedImage = base64Decode(widget.initialProfilePicture!);
    }
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final result = {
      "title": _titleController.text.trim(),
      "biography": _bioController.text.trim(),
      "profilePicture": _base64Image ?? "AA=="
    };

    Navigator.pop(context, result); // vraća JSON kao rezultat
  }
  Widget _buildImagePicker() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
            image: DecorationImage(
              image: _selectedImage != null
                  ? MemoryImage(_selectedImage!)
                  : const AssetImage("assets/images/placeholder.png") as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage,
                        child: _buildImagePicker(),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: "Title"),
                        validator: (value) => value == null || value.isEmpty ? "Enter title" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _bioController,
                        maxLines: 4,
                        decoration: const InputDecoration(labelText: "Biography"),
                        validator: (value) => value == null || value.isEmpty ? "Enter biography" : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final result = {
                                "title": _titleController.text.trim(),
                                "biography": _bioController.text.trim(),
                                "profilePicture": _base64Image ?? "AA=="
                              };

                              try {
                                Navigator.pop(context, result);
                              } catch (e) {
                                await showErrorAlert(context, "Update failed: $e");
                              }
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

}
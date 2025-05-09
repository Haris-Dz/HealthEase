import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/utils.dart';

class EditDoctorDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialBio;

  const EditDoctorDialog({super.key, this.initialTitle, this.initialBio});

  @override
  State<EditDoctorDialog> createState() => _EditDoctorDialogState();
}

class _EditDoctorDialogState extends State<EditDoctorDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _bioController.text = widget.initialBio ?? '';
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
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: "Title"),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Enter title"
                                    : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _bioController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: "Biography",
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Enter biography"
                                    : null,
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
                              };

                              try {
                                Navigator.pop(context, result);
                              } catch (e) {
                                await showErrorAlert(
                                  context,
                                  "Update failed: $e",
                                );
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

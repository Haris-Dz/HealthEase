import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/specialization.dart';

class SpecializationDialog extends StatefulWidget {
  final Specialization? specialization;
  final void Function(String name, String description) onSave;

  const SpecializationDialog({
    super.key,
    this.specialization,
    required this.onSave,
  });

  @override
  State<SpecializationDialog> createState() => _SpecializationDialogState();
}

class _SpecializationDialogState extends State<SpecializationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.specialization?.name ?? '',
    );
    _descController = TextEditingController(
      text: widget.specialization?.description ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.specialization != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 400,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? "Edit Specialization" : "Add Specialization",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Specialization Name",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Required"
                                  : null,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Required"
                                  : null,
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.onSave(
                                _nameController.text.trim(),
                                _descController.text.trim(),
                              );
                              Navigator.pop(
                                context,
                                isEditing ? 'updated' : 'added',
                              );
                            }
                          },
                          child: Text(isEditing ? "Update" : "Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.close),
                splashRadius: 18,
                tooltip: "Close",
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/role.dart';

class RoleDialog extends StatefulWidget {
  final Role? role;
  final void Function(String name, String description) onSave;

  const RoleDialog({super.key, this.role, required this.onSave});

  @override
  State<RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends State<RoleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.role?.roleName ?? '');
    _descController = TextEditingController(
      text: widget.role?.description ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.role != null;

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
                      isEditing ? "Edit Role" : "Add Role",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Role Name (editable or display only)
                    const Text(
                      "Role Name",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    isEditing
                        ? Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey.shade100,
                          ),
                          child: Text(
                            _nameController.text,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        )
                        : TextFormField(
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

                    // Description
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
                    ),
                    const SizedBox(height: 24),

                    // Buttons
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
                            backgroundColor: Colors.blue, // boja pozadine
                            foregroundColor: Colors.white, // boja teksta
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

            // X dugme
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

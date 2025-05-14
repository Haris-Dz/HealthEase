import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/appointment_type.dart';

class AppointmentTypeDialog extends StatefulWidget {
  final AppointmentType? appointmentType;
  final void Function(String name, double price) onSave;

  const AppointmentTypeDialog({
    super.key,
    this.appointmentType,
    required this.onSave,
  });

  @override
  State<AppointmentTypeDialog> createState() => _AppointmentTypeDialogState();
}

class _AppointmentTypeDialogState extends State<AppointmentTypeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.appointmentType?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.appointmentType?.price?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.appointmentType != null;

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
                      isEditing
                          ? "Edit Appointment Type"
                          : "Add Appointment Type",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Appointment type name",
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
                      "Price",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        final number = double.tryParse(value);
                        if (number == null || number < 0) {
                          return "Enter valid price";
                        }
                        return null;
                      },
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
                              final price = double.parse(
                                _priceController.text.trim(),
                              );
                              widget.onSave(_nameController.text.trim(), price);
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:healthease_desktop/providers/working_hours_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';

class EditWorkingHoursDialog extends StatefulWidget {
  final int userId;

  const EditWorkingHoursDialog({super.key, required this.userId});

  @override
  State<EditWorkingHoursDialog> createState() => _EditWorkingHoursDialogState();
}

class _EditWorkingHoursDialogState extends State<EditWorkingHoursDialog> {
  final Map<DayOfWeek, TextEditingController> startControllers = {};
  final Map<DayOfWeek, TextEditingController> endControllers = {};
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  late List<int> existingDays;

  @override
  void initState() {
    super.initState();
    _fetchWorkingHours();
  }

  String? _validateTime(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final regex = RegExp(r'^\d{2}:\d{2}$');
    if (!regex.hasMatch(value)) return "Format must be HH:mm";

    final parts = value.split(':');
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null || hour > 23 || minute > 59) {
      return "Invalid time";
    }
    return null;
  }

  Future<void> _fetchWorkingHours() async {
    try {
      final provider = Provider.of<WorkingHoursProvider>(
        context,
        listen: false,
      );
      final response = await provider.get(
        filter: {"UserId": widget.userId},
        retrieveAll: true,
      );

      existingDays = [];

      for (var entry in response.resultList) {
        if (entry.day != null &&
            entry.day! >= 0 &&
            entry.day! < DayOfWeek.values.length) {
          final day = DayOfWeek.values[entry.day!];
          existingDays.add(entry.day!);
          startControllers[day] = TextEditingController(
            text: entry.startTime.toString().substring(0, 5),
          );
          endControllers[day] = TextEditingController(
            text: entry.endTime.toString().substring(0, 5),
          );
        }
      }

      if (mounted) setState(() => isLoading = false);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorAlert(context, "Failed to load working hours: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 500,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Edit Working Hours",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...DayOfWeek.values.map((day) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(day.name)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        controller:
                                            startControllers[day] ??=
                                                TextEditingController(),
                                        decoration: const InputDecoration(
                                          labelText: "Start",
                                          hintText: "08:00",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: _validateTime,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        controller:
                                            endControllers[day] ??=
                                                TextEditingController(),
                                        decoration: const InputDecoration(
                                          labelText: "End",
                                          hintText: "16:00",
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: _validateTime,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final provider =
                                    Provider.of<WorkingHoursProvider>(
                                      context,
                                      listen: false,
                                    );

                                final existing = await provider.get(
                                  filter: {"UserId": widget.userId},
                                  retrieveAll: true,
                                );

                                // Mapp day -> existingWorkingHours
                                final existingMap = {
                                  for (var wh in existing.resultList)
                                    if (wh.day != null) wh.day!: wh,
                                };

                                final updates = <Map<String, dynamic>>[];

                                for (var day in DayOfWeek.values) {
                                  final startText =
                                      startControllers[day]?.text.trim();
                                  final endText =
                                      endControllers[day]?.text.trim();
                                  final dayIndex = day.index;

                                  final existsInDb = existingMap.containsKey(
                                    dayIndex,
                                  );
                                  final hasInput =
                                      (startText != null &&
                                          startText.isNotEmpty) &&
                                      (endText != null && endText.isNotEmpty);

                                  if (hasInput) {
                                    // Insert or update
                                    updates.add({
                                      "userId": widget.userId,
                                      "day": dayIndex,
                                      "startTime": startText,
                                      "endTime": endText,
                                    });
                                  } else if (!hasInput && existsInDb) {
                                    // Delete
                                    updates.add({
                                      "userId": widget.userId,
                                      "day": dayIndex,
                                      "startTime": null,
                                      "endTime": null,
                                    });
                                  }
                                }

                                try {
                                  if (updates.isNotEmpty) {
                                    await provider.bulkUpsert(updates);
                                    await _fetchWorkingHours();
                                  }
                                  if (mounted) Navigator.pop(context, true);
                                } catch (e) {
                                  showErrorAlert(
                                    context,
                                    "Failed to save working hours: $e",
                                  );
                                }
                              },

                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum DayOfWeek {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}

extension DayOfWeekExtension on DayOfWeek {
  String get name {
    switch (this) {
      case DayOfWeek.monday:
        return "Monday";
      case DayOfWeek.tuesday:
        return "Tuesday";
      case DayOfWeek.wednesday:
        return "Wednesday";
      case DayOfWeek.thursday:
        return "Thursday";
      case DayOfWeek.friday:
        return "Friday";
      case DayOfWeek.saturday:
        return "Saturday";
      case DayOfWeek.sunday:
        return "Sunday";
    }
  }
}

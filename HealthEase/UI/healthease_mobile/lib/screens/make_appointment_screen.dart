import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/appointment_type.dart';
import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/models/workingHours.dart';
import 'package:healthease_mobile/providers/appointment_types_provider.dart';
import 'package:healthease_mobile/providers/appointments_provider.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/screens/appointments_screen.dart';
import 'package:intl/intl.dart';

class MakeAppointmentScreen extends StatefulWidget {
  final Doctor doctor;
  const MakeAppointmentScreen({super.key, required this.doctor});

  @override
  State<MakeAppointmentScreen> createState() => _MakeAppointmentScreenState();
}

class _MakeAppointmentScreenState extends State<MakeAppointmentScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  AppointmentType? _selectedType;

  List<AppointmentType> _types = [];
  final _typeProvider = AppointmentTypesProvider();
  final _appointmentsProvider = AppointmentsProvider();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTypes();
  }

  Future<void> _loadTypes() async {
    final result = await _typeProvider.get();
    setState(() => _types = result.resultList);
  }

  List<int> get workingDays =>
      widget.doctor.workingHours?.map((w) => w.day!).toList() ?? [];

  List<TimeOfDay> getWorkingHoursForSelectedDay() {
    if (_selectedDate == null) return [];

    final weekday = _selectedDate!.weekday;
    final hours = widget.doctor.workingHours?.firstWhere(
      (e) => e.day == weekday,
      orElse: () => WorkingHours(),
    );

    final start = _parseTime(hours?.startTime);
    final end = _parseTime(hours?.endTime);
    if (start == null || end == null) return [];

    List<TimeOfDay> slots = [];
    for (int h = start.hour; h < end.hour; h++) {
      slots.add(TimeOfDay(hour: h, minute: 0));
    }
    return slots;
  }

  TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null) return null;
    final parts = timeStr.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _submitAppointment() async {
    try {
      final request = {
        "appointmentDate": _selectedDate!.toIso8601String(),
        "appointmentTime":
            "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
        "note": _noteController.text,
        "appointmentTypeId": _selectedType!.appointmentTypeId,
        "doctorId": widget.doctor.doctorId,
        "patientId": AuthProvider.patientId!,
      };

      await _appointmentsProvider.insert(request);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AppointmentsScreen()),
        );
      }
    } catch (e) {
      debugPrint("Error booking appointment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Make Appointment",
      currentRoute: "MakeAppointment",
      showBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Appointment Type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButton<AppointmentType>(
              isExpanded: true,
              value: _selectedType,
              hint: const Text("Select type"),
              items:
                  _types.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        "${type.name} - ${type.price?.toStringAsFixed(2) ?? '0.00'} \$",
                      ),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _selectedType = value),
            ),
            const SizedBox(height: 20),
            const Text(
              "Note (optional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Write a short note (optional)...",
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 20),
            const Text(
              "Select Date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CalendarDatePicker(
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 360)),
              initialDate: _focusedDay,
              onDateChanged: (selected) {
                setState(() {
                  _selectedDate = selected;
                  _selectedTime = null;
                });
              },
              selectableDayPredicate:
                  (date) => workingDays.contains(date.weekday),
            ),

            const SizedBox(height: 20),
            if (_selectedDate != null) ...[
              const Text(
                "Select Time",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButton<TimeOfDay>(
                isExpanded: true,
                value:
                    getWorkingHoursForSelectedDay().contains(_selectedTime)
                        ? _selectedTime
                        : null,
                hint: const Text("Select available time"),
                items:
                    getWorkingHoursForSelectedDay().map((time) {
                      return DropdownMenuItem(
                        value: time,
                        child: Text(
                          DateFormat.Hm().format(
                            DateTime(0, 0, 0, time.hour, time.minute),
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _selectedTime = value),
              ),
            ],

            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed:
                        (_selectedDate != null &&
                                _selectedTime != null &&
                                _selectedType != null)
                            ? _submitAppointment
                            : null,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Book Appointment"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedDate == null ||
                      _selectedTime == null ||
                      _selectedType == null)
                    const Text(
                      "Please select appointment type, date and time",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/appointment.dart';
import 'package:healthease_mobile/models/appointment_type.dart';
import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/models/workingHours.dart';
import 'package:healthease_mobile/providers/appointment_types_provider.dart';
import 'package:healthease_mobile/providers/appointments_provider.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:healthease_mobile/screens/appointments_screen.dart';
import 'package:intl/intl.dart';

class MakeAppointmentScreen extends StatefulWidget {
  final Doctor doctor;
  const MakeAppointmentScreen({super.key, required this.doctor});

  @override
  State<MakeAppointmentScreen> createState() => _MakeAppointmentScreenState();
}

class _MakeAppointmentScreenState extends State<MakeAppointmentScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  AppointmentType? _selectedType;
  bool _isLoading = true;

  List<AppointmentType> _types = [];
  List<Appointment> _appointments = [];

  final _typeProvider = AppointmentTypesProvider();
  final _appointmentsProvider = AppointmentsProvider();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _loadTypes();
    await _loadAppointments();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _loadTypes() async {
    final result = await _typeProvider.get();
    if (!mounted) return;
    setState(() => _types = result.resultList);
  }

  Future<void> _loadAppointments() async {
    final result = await _appointmentsProvider.get(
      filter: {"doctorId": widget.doctor.doctorId},
    );
    if (!mounted) return;
    setState(() {
      _appointments = result.resultList;
    });
  }

  List<int> get workingDays {
    final raw = widget.doctor.workingHours;
    if (raw == null) return [];

    return raw
        .where((w) => w.day != null && w.startTime != null && w.endTime != null)
        .map((w) => w.day == 0 ? 7 : w.day!)
        .toSet()
        .toList();
  }

  List<TimeOfDay> getWorkingHoursForDay(DateTime date) {
    final weekday = date.weekday;

    final hours = widget.doctor.workingHours?.firstWhere(
      (e) =>
          (e.day == 0 ? 7 : e.day) == weekday &&
          e.startTime != null &&
          e.endTime != null,
      orElse: () => WorkingHours(),
    );

    if (hours == null || hours.startTime == null || hours.endTime == null) {
      return [];
    }

    final start = _parseTime(hours.startTime);
    final end = _parseTime(hours.endTime);
    if (start == null || end == null) return [];

    List<TimeOfDay> slots = [];
    for (int h = start.hour; h < end.hour; h++) {
      slots.add(TimeOfDay(hour: h, minute: 0));
    }
    return slots;
  }

  bool isDayFullyBooked(DateTime date) {
    final totalSlots = getWorkingHoursForDay(date).length;
    final bookedSlots =
        _appointments
            .where(
              (a) =>
                  DateTime.parse(a.appointmentDate!).year == date.year &&
                  DateTime.parse(a.appointmentDate!).month == date.month &&
                  DateTime.parse(a.appointmentDate!).day == date.day &&
                  (a.status == 'Pending' || a.status == 'Approved'),
            )
            .map((a) => a.appointmentTime)
            .toSet()
            .length;

    return totalSlots > 0 && bookedSlots >= totalSlots;
  }

  TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null) return null;
    final parts = timeStr.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  TimeOfDay? parseTimeOfDay(String timeStr) {
    try {
      final parts = timeStr.split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  DateTime getFirstSelectableDate() {
    DateTime date = DateTime.now();
    int attempts = 0;

    while (!workingDays.contains(date.weekday) || isDayFullyBooked(date)) {
      date = date.add(const Duration(days: 1));
      attempts++;
      if (attempts > 365) break;
    }

    return date;
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
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppointmentsScreen()),
      );
      if (!mounted) return;
      showSuccessAlert(context, "Successfully booked an appointment");
    } catch (e) {
      if (!mounted) return;
      showErrorAlert(context, "Error booking appointment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final validInitialDate = getFirstSelectableDate();
    final bool isInitialValid =
        workingDays.contains(validInitialDate.weekday) &&
        !isDayFullyBooked(validInitialDate);
    return MasterScreen(
      title: "Make Appointment",
      currentRoute: "MakeAppointment",
      showBackButton: true,
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : (widget.doctor.workingHours == null ||
                  widget.doctor.workingHours!.isEmpty)
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.block, size: 60, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        const Text(
                          "This doctor has no available working hours at the moment.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : SingleChildScrollView(
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
                          _types
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    "${type.name} - ${type.price?.toStringAsFixed(2) ?? '0.00'} \$",
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => setState(() => _selectedType = value),
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
                        hintText: "Write a short note ...",
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Select Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (!isInitialValid)
                      const Text(
                        "No available dates for appointment.",
                        style: TextStyle(color: Colors.redAccent),
                      )
                    else
                      CalendarDatePicker(
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 360)),
                        initialDate: validInitialDate,
                        onDateChanged: (selected) {
                          setState(() {
                            _selectedDate = selected;
                            _selectedTime = null;
                          });
                        },
                        selectableDayPredicate: (date) {
                          if (!workingDays.contains(date.weekday)) return false;
                          return !isDayFullyBooked(date);
                        },
                      ),

                    const SizedBox(height: 20),
                    if (_selectedDate != null) ...[
                      const Text(
                        "Select Time",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Builder(
                        builder: (context) {
                          final allSlots = getWorkingHoursForDay(
                            _selectedDate!,
                          );
                          final bookedSlots =
                              _appointments
                                  .where(
                                    (a) =>
                                        DateTime.parse(
                                              a.appointmentDate!,
                                            ).year ==
                                            _selectedDate!.year &&
                                        DateTime.parse(
                                              a.appointmentDate!,
                                            ).month ==
                                            _selectedDate!.month &&
                                        DateTime.parse(
                                              a.appointmentDate!,
                                            ).day ==
                                            _selectedDate!.day &&
                                        (a.status == 'Pending' ||
                                            a.status == 'Approved'),
                                  )
                                  .map(
                                    (a) => parseTimeOfDay(a.appointmentTime!),
                                  )
                                  .whereType<TimeOfDay>()
                                  .toList();

                          return DropdownButton<TimeOfDay>(
                            isExpanded: true,
                            value:
                                _selectedTime != null &&
                                        bookedSlots.any(
                                          (b) =>
                                              b.hour == _selectedTime!.hour &&
                                              b.minute == _selectedTime!.minute,
                                        )
                                    ? null
                                    : _selectedTime,
                            hint: const Text("Select available time"),
                            items:
                                allSlots.map((slot) {
                                  final isBooked = bookedSlots.any(
                                    (b) =>
                                        b.hour == slot.hour &&
                                        b.minute == slot.minute,
                                  );

                                  final timeLabel = DateFormat.Hm().format(
                                    DateTime(0, 0, 0, slot.hour, slot.minute),
                                  );

                                  return DropdownMenuItem<TimeOfDay>(
                                    value: isBooked ? null : slot,
                                    enabled: !isBooked,
                                    child: Tooltip(
                                      message:
                                          isBooked
                                              ? "Already booked"
                                              : "Available",
                                      child: Row(
                                        children: [
                                          if (isBooked)
                                            const Icon(
                                              Icons.block,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                          if (isBooked)
                                            const SizedBox(width: 6),
                                          Text(
                                            timeLabel,
                                            style: TextStyle(
                                              color:
                                                  isBooked
                                                      ? Colors.grey
                                                      : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged:
                                (value) =>
                                    setState(() => _selectedTime = value),
                          );
                        },
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
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

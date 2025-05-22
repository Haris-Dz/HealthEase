import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/appointment.dart';
import 'package:healthease_desktop/models/doctor.dart';
import 'package:healthease_desktop/providers/appointments_provider.dart';
import 'package:healthease_desktop/providers/doctors_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Appointment> _appointments = [];
  List<Appointment> _filteredAppointments = [];
  List<Doctor> _doctors = [];
  List<String> _statusOptions = [];

  Doctor? _selectedDoctor;
  String? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = true;

  bool get isDoctor =>
      AuthProvider.userRoles?.any((role) => role.role?.roleId == 2) ?? false;
  int? get doctorId => AuthProvider.userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _loadData();
      _loadStatusOptions();
    }
  }

  Future<void> _loadStatusOptions() async {
    final appointmentsProvider = Provider.of<AppointmentsProvider>(
      context,
      listen: false,
    );
    final options = await appointmentsProvider.getStatusOptions();
    if (!mounted) return;
    setState(() {
      _statusOptions = options;
    });
  }

  Future<void> _loadData() async {
    final appointmentsProvider = Provider.of<AppointmentsProvider>(
      context,
      listen: false,
    );
    final doctorsProvider = Provider.of<DoctorsProvider>(
      context,
      listen: false,
    );

    final appointmentsResponse = await appointmentsProvider.get();
    final doctorsResponse = await doctorsProvider.get();
    if (!mounted) return;
    setState(() {
      _appointments = appointmentsResponse.resultList;
      _filteredAppointments = _filterAppointments(_appointments);
      _doctors = doctorsResponse.resultList;
      _isLoading = false;
    });
  }

  List<Appointment> _filterAppointments(List<Appointment> all) {
    return all.where((a) {
      if (isDoctor && a.doctor?.userId != doctorId) return false;

      final matchesDoctor =
          isDoctor ||
          _selectedDoctor == null ||
          a.doctor?.doctorId == _selectedDoctor!.doctorId;
      final matchesStatus =
          _selectedStatus == null ||
          a.status?.toLowerCase() == _selectedStatus!.toLowerCase();
      final appointmentDate = DateTime.tryParse(a.appointmentDate ?? "");
      final matchesStart =
          _startDate == null ||
          (appointmentDate != null &&
              appointmentDate.isAfter(
                _startDate!.subtract(const Duration(days: 1)),
              ));
      final matchesEnd =
          _endDate == null ||
          (appointmentDate != null &&
              appointmentDate.isBefore(_endDate!.add(const Duration(days: 1))));
      return matchesDoctor && matchesStatus && matchesStart && matchesEnd;
    }).toList();
  }

  void _applyFilters() {
    setState(() {
      _filteredAppointments = _filterAppointments(_appointments);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFE3F2FD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildFilters(),
          const SizedBox(height: 20),
          _isLoading
              ? const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
              : _buildTableContainer(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        if (!isDoctor)
          Expanded(
            child: DropdownButtonFormField<Doctor>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: "Doctor",
                border: OutlineInputBorder(),
              ),
              value: _selectedDoctor,
              items: [
                const DropdownMenuItem(value: null, child: Text("All")),
                ..._doctors.map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Text("${d.user?.firstName} ${d.user?.lastName}"),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedDoctor = value);
                _applyFilters();
              },
            ),
          ),
        if (!isDoctor) const SizedBox(width: 12),

        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Status",
              border: OutlineInputBorder(),
            ),
            value: _selectedStatus,
            items: [
              const DropdownMenuItem(value: null, child: Text("All")),
              ..._statusOptions.map(
                (status) =>
                    DropdownMenuItem(value: status, child: Text(status)),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedStatus = value);
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 12),
        // START DATE
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              alignment: Alignment.centerLeft,
            ),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _startDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  _startDate = picked;
                  _applyFilters();
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _startDate == null
                          ? "Start Date"
                          : formatDate(_startDate!),
                      style: TextStyle(
                        color: _startDate == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ],
                ),
                if (_startDate != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _startDate = null;
                        _applyFilters();
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // END DATE
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              alignment: Alignment.centerLeft,
            ),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _endDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  _endDate = picked;
                  _applyFilters();
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _endDate == null ? "End Date" : formatDate(_endDate!),
                      style: TextStyle(
                        color: _endDate == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ],
                ),
                if (_endDate != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _endDate = null;
                        _applyFilters();
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _processAppointment(
    int appointmentId,
    bool approve,
    String message,
    String appointmentDate,
    String appointmentTime,
    bool? isPaid,
    String? paymentDate,
  ) async {
    final provider = Provider.of<AppointmentsProvider>(context, listen: false);

    try {
      await provider.update(appointmentId, {
        "appointmentDate": appointmentDate,
        "appointmentTime": appointmentTime,
        "approve": approve,
        "statusMessage": message,
        "isPaid": isPaid,
        "paymentDate": paymentDate,
      });
      if (!mounted) return;
      await _loadData();
      await showSuccessAlert(
        context,
        "Appointment successfully ${approve ? "approved" : "declined"}.",
      );
    } catch (e) {
      await showErrorAlert(context, "Failed to process appointment: $e");
    }
  }

  void _showDetailsDialog(Appointment appointment) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Container(
                width: 600,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Process Appointment",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      runSpacing: 12,
                      children: [
                        _infoRow(
                          "Doctor",
                          "${appointment.doctor?.user?.firstName ?? ''} ${appointment.doctor?.user?.lastName ?? ''}",
                        ),
                        _infoRow(
                          "Patient",
                          "${appointment.patient?.firstName ?? ''} ${appointment.patient?.lastName ?? ''}",
                        ),
                        _infoRow(
                          "Date",
                          formatDateString(appointment.appointmentDate),
                        ),
                        _infoRow(
                          "Time",
                          formatTimeString(appointment.appointmentTime),
                        ),
                        _infoRow(
                          "Type",
                          appointment.appointmentType?.name ?? '-',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _messageController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Status message",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_isDeclineAttempt &&
                              (value == null || value.trim().isEmpty)) {
                            return "Please provide a message when declining.";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            _isDeclineAttempt = true;
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              _processAppointment(
                                appointment.appointmentId!,
                                false,
                                _messageController.text.trim(),
                                appointment.appointmentDate!,
                                appointment.appointmentTime!,
                                appointment.isPaid,
                                appointment.paymentDate,
                              );
                            }
                          },
                          child: const Text("Decline"),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            _isDeclineAttempt = false;
                            Navigator.pop(context);
                            _processAppointment(
                              appointment.appointmentId!,
                              true,
                              _messageController.text.trim(),
                              appointment.appointmentDate!,
                              appointment.appointmentTime!,
                              appointment.isPaid,
                              appointment.paymentDate,
                            );
                          },
                          child: const Text("Approve"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 11,
                right: 11,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: "Close",
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isDeclineAttempt = false;

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildTableContainer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildDataTable(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1000),
        child: DataTable(
          columnSpacing: 40,
          headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
          columns: const [
            DataColumn(label: Text("Doctor")),
            DataColumn(label: Text("Date")),
            DataColumn(label: Text("Time")),
            DataColumn(label: Text("Type")),
            DataColumn(label: Text("Status")),
          ],
          rows:
              _filteredAppointments.map((a) {
                final statusColor =
                    a.status?.toLowerCase() == 'approved'
                        ? Colors.blue
                        : a.status?.toLowerCase() == 'pending'
                        ? Colors.orange
                        : a.status?.toLowerCase() == 'paid'
                        ? Colors.green
                        : Colors.red;
                final statusIcon =
                    a.status?.toLowerCase() == 'approved'
                        ? Icons.check_circle
                        : a.status?.toLowerCase() == 'pending'
                        ? Icons.access_time
                        : a.status?.toLowerCase() == 'paid'
                        ? Icons.check_circle
                        : Icons.cancel;

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        "${a.doctor?.user?.firstName ?? '-'} ${a.doctor?.user?.lastName ?? ''}",
                      ),
                    ),
                    DataCell(Text(formatDateString(a.appointmentDate))),
                    DataCell(Text(formatTimeString(a.appointmentTime))),
                    DataCell(Text(a.appointmentType?.name ?? '-')),
                    DataCell(
                      Row(
                        children: [
                          Icon(statusIcon, size: 18, color: statusColor),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              a.status ?? '-',
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if ((a.status?.toLowerCase() ?? '') == 'pending')
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                fixedSize: const Size(100, 36),
                              ),
                              onPressed: () => _showDetailsDialog(a),
                              child: const Text("Process"),
                            )
                          else
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                fixedSize: const Size(100, 36),
                              ),
                              onPressed: null,
                              child: const Text(
                                "Processed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/appointment.dart';
import 'package:healthease_mobile/providers/appointments_provider.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _appointmentsProvider = AppointmentsProvider();
  List<Appointment> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      final result = await _appointmentsProvider.get(
        filter: {'PatientId': AuthProvider.patientId},
        includeTables: 'Doctor.User,Patient,AppointmentType', // 👈 Dodano
      );
      setState(() {
        _appointments = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    switch (status.toLowerCase()) {
      case 'approved':
        badgeColor = Colors.green.shade600;
        break;
      case 'rejected':
        badgeColor = Colors.red.shade700;
        break;
      case 'paid':
        badgeColor = Colors.blue.shade800;
        break;
      case 'pending':
      default:
        badgeColor = Colors.orange.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        border: Border.all(color: badgeColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "My Appointments",
      currentRoute: "Appointments",
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _appointments.isEmpty
              ? const Center(child: Text("No appointments found"))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final a = _appointments[index];
                  final type = a.appointmentType;

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Dr. ${a.doctor?.user?.firstName ?? ''} ${a.doctor?.user?.lastName ?? ''}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              _buildStatusBadge(a.status ?? 'Unknown'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (type != null)
                            Text(
                              "${type.name} - ${type.price!.toStringAsFixed(2)} \$",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            "Date: ${formatDateString(a.appointmentDate?.substring(0, 10))}",
                          ),
                          Text("Time: ${a.appointmentTime ?? 'N/A'}"),
                          if (a.note != null && a.note!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text("Note: ${a.note}"),
                            ),
                          if (a.statusMessage != null &&
                              a.statusMessage!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Message: ${a.statusMessage}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          if (!a.isPaid! &&
                              a.status?.toLowerCase() == 'approved')
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Payment screen
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade800,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.payment),
                                label: const Text("Pay Now"),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

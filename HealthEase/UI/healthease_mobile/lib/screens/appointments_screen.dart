import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/appointment.dart';
import 'package:healthease_mobile/providers/appointments_provider.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

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
        includeTables: 'Doctor.User,Patient,AppointmentType',
      );
      if (!mounted) return;
      setState(() {
        _appointments = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    switch (status.toLowerCase()) {
      case 'approved':
        badgeColor = Colors.green.shade600;
        break;
      case 'declined':
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
                                onPressed: () async {
                                  var clientId =
                                      "AURtCEWnvA03YzChyXThPXeyY2beJP1RFJlUAzpjk1tBD8Xu166eActAUmwQmf_moWiVAzmxVVCMPdFp";
                                  var secret =
                                      "ECC5-TP5yuNrOYTOXPUvGg6m49UdvPmKOKb3yhG2_r-R-5rdHr7Ryj0NuFWkA6zGKIXWzvk2bmCcpxaw";

                                  if (clientId == null || secret == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "PayPal credentials missing",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final appointment = a;
                                  final price =
                                      appointment.appointmentType?.price
                                          ?.toStringAsFixed(2) ??
                                      "0.00";

                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PaypalCheckoutView(
                                            sandboxMode: true,
                                            clientId: clientId,
                                            secretKey: secret,
                                            transactions: [
                                              {
                                                "amount": {
                                                  "total": price,
                                                  "currency": "USD",
                                                  "details": {
                                                    "subtotal": price,
                                                    "shipping": '0',
                                                    "shipping_discount": 0,
                                                  },
                                                },
                                                "description":
                                                    "Appointment payment",
                                                "item_list": {
                                                  "items": [
                                                    {
                                                      "name":
                                                          appointment
                                                              .appointmentType
                                                              ?.name ??
                                                          "Appointment",
                                                      "quantity": 1,
                                                      "price": price,
                                                      "currency": "USD",
                                                    },
                                                  ],
                                                },
                                              },
                                            ],
                                            note: "Thank you for your payment",
                                            onSuccess: (Map params) async {
                                              if (!context.mounted) return;

                                              print(
                                                "👉 Full PayPal Params: ${jsonEncode(params)}",
                                              );

                                              final data = params['data'];

                                              final transaction = {
                                                "amount": double.parse(
                                                  data['transactions'][0]['amount']['total'],
                                                ),
                                                "paymentMethod":
                                                    data['payer']['payment_method'],
                                                "paymentId": data['id'],
                                                "payerId":
                                                    data['payer']['payer_info']['payer_id'],
                                                "patientId":
                                                    appointment.patientId,
                                                "appointmentId":
                                                    appointment.appointmentId,
                                              };

                                              Navigator.pop(context, true);
                                              final updatedAppointment = {
                                                ...appointment.toJson(),
                                                "isPaid": true,
                                                "status": "paid",
                                                "transactionInsert":
                                                    transaction,
                                              };
                                              await _appointmentsProvider
                                                  .update(
                                                    appointment.appointmentId!,
                                                    updatedAppointment,
                                                  );
                                              showSuccessAlert(
                                                context,
                                                "Payment successful",
                                              );
                                              if (!mounted) return;
                                              setState(() {
                                                _fetchAppointments();
                                              });
                                            },

                                            onError: (error) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Payment error: $error",
                                                  ),
                                                ),
                                              );
                                            },
                                            onCancel: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                    ),
                                  );

                                  if (result == true) {
                                    _fetchAppointments();
                                  }
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

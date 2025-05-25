import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/appointment.dart';
import 'package:healthease_mobile/models/review.dart';
import 'package:healthease_mobile/providers/appointments_provider.dart';
import 'package:healthease_mobile/providers/review_provider.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:healthease_mobile/screens/paypal_screen.dart';
import 'package:provider/provider.dart';

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

  DateTime _getAppointmentDateTime(Appointment a) {
    final date = DateTime.parse(a.appointmentDate!);
    final timeParts = a.appointmentTime!.split(":");
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
    );
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

  Future<Review?> _getReview(int appointmentId) async {
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    final result = await reviewProvider.get(
      filter: {
        'isDeleted': true,
        'AppointmentId': appointmentId,
        'PatientId': AuthProvider.patientId,
      },
    );
    if (result.resultList.isNotEmpty) {
      return result.resultList.first;
    }
    return null;
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
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 24),
                    Text(
                      "No Appointments yet",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final a = _appointments[index];
                  final type = a.appointmentType;

                  final isPaid = a.isPaid == true;
                  final appointmentDateTime = _getAppointmentDateTime(a);
                  final isPast = appointmentDateTime.isBefore(DateTime.now());
                  final canReview = isPaid && isPast;

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
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Time:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formatDateString(
                                        a.appointmentDate?.substring(0, 10),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      a.appointmentTime ?? 'N/A',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                                  final appointment = a;
                                  final price =
                                      appointment.appointmentType?.price
                                          ?.toStringAsFixed(2) ??
                                      "0.00";
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PaypalScreen(
                                            appointment: appointment,
                                            price: price,
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

                          if (isPaid && !isPast)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "You can leave a review after your appointment.",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          if (canReview)
                            FutureBuilder<Review?>(
                              future: _getReview(a.appointmentId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: LinearProgressIndicator(),
                                  );
                                }
                                final review = snapshot.data;

                                if (review == null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange.shade700,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(Icons.star_rate_rounded),
                                      label: const Text("Leave Review"),
                                      onPressed: () async {
                                        final submitted =
                                            await showDialog<bool>(
                                              context: context,
                                              builder:
                                                  (context) =>
                                                      LeaveReviewDialog(
                                                        appointmentId:
                                                            a.appointmentId!,
                                                        doctorId: a.doctorId!,
                                                      ),
                                            );
                                        if (submitted == true) setState(() {});
                                      },
                                    ),
                                  );
                                }
                                if (review.isDeleted == true) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Chip(
                                      avatar: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        "Reviewed",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.grey.shade600,
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Chip(
                                        avatar: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        label: const Text(
                                          "Reviewed",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green.shade600,
                                      ),
                                      const SizedBox(width: 10),
                                      Tooltip(
                                        message: "Edit your review",
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blueAccent,
                                          ),
                                          onPressed: () async {
                                            final submitted = await showDialog<
                                              bool
                                            >(
                                              context: context,
                                              builder:
                                                  (
                                                    context,
                                                  ) => LeaveReviewDialog(
                                                    appointmentId:
                                                        a.appointmentId!,
                                                    doctorId: a.doctorId!,
                                                    initialRating:
                                                        review.rating
                                                            ?.toInt() ??
                                                        5,
                                                    initialComment:
                                                        review.comment ?? "",
                                                    reviewId: review.reviewId,
                                                  ),
                                            );
                                            if (submitted == true)
                                              setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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

class LeaveReviewDialog extends StatefulWidget {
  final int appointmentId;
  final int doctorId;
  final int? initialRating;
  final String? initialComment;
  final int? reviewId;

  const LeaveReviewDialog({
    super.key,
    required this.appointmentId,
    required this.doctorId,
    this.initialRating,
    this.initialComment,
    this.reviewId,
  });

  @override
  State<LeaveReviewDialog> createState() => _LeaveReviewDialogState();
}

class _LeaveReviewDialogState extends State<LeaveReviewDialog> {
  late int _rating;
  late TextEditingController _commentController;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 5;
    _commentController = TextEditingController(
      text: widget.initialComment ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

    return AlertDialog(
      title: Text(
        widget.reviewId == null ? "Rate Your Experience" : "Edit Your Review",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  _rating > index ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: "Comment (optional)",
              border: OutlineInputBorder(),
            ),
            minLines: 1,
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              _submitting ? null : () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed:
              _submitting
                  ? null
                  : () async {
                    setState(() => _submitting = true);
                    try {
                      if (widget.reviewId == null) {
                        await reviewProvider.insert({
                          'appointmentId': widget.appointmentId,
                          'rating': _rating,
                          'comment': _commentController.text.trim(),
                        });
                      } else {
                        await reviewProvider.update(widget.reviewId!, {
                          'appointmentId': widget.appointmentId,
                          'rating': _rating,
                          'comment': _commentController.text.trim(),
                        });
                      }
                      if (context.mounted) Navigator.of(context).pop(true);
                    } catch (_) {
                      if (context.mounted) {
                        await showErrorAlert(
                          context,
                          "Failed to submit review.",
                        );
                      }
                    } finally {
                      setState(() => _submitting = false);
                    }
                  },
          child:
              _submitting
                  ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(),
                  )
                  : const Text("Submit"),
        ),
      ],
    );
  }
}

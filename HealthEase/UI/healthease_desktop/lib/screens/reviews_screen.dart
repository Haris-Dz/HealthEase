import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/review.dart';
import 'package:healthease_desktop/providers/reviews_provider.dart';
import 'package:healthease_desktop/providers/doctors_provider.dart';
import 'package:intl/intl.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _reviewProvider = ReviewsProvider();

  int? _selectedRating;
  String? _doctorNameGTE;
  String? _patientNameGTE;
  DateTime? _createdAfter;
  DateTime? _createdBefore;

  List<Review> _reviews = [];
  bool _isLoading = false;

  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();

  int? _doctorId; // <- REAL DoctorId!

  bool get isDoctor {
    return AuthProvider.userRoles?.any((role) => role.role?.roleId == 2) ??
        false;
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDoctorIdAndFetchReviews();
  }

  Future<void> _loadDoctorIdAndFetchReviews() async {
    if (isDoctor) {
      // Učitaj DoctorId za trenutnog usera
      try {
        final doctors = await DoctorsProvider().get(
          filter: {'UserId': AuthProvider.userId},
        );
        if (doctors.resultList.isNotEmpty) {
          _doctorId = doctors.resultList.first.doctorId;
        }
      } catch (_) {}
    }
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);

    final filter = <String, dynamic>{
      if (isDoctor && _doctorId != null) "DoctorId": _doctorId,
      if (!isDoctor && _selectedRating != null) "Rating": _selectedRating,
      if (!isDoctor && _doctorNameGTE?.isNotEmpty == true)
        "DoctorNameGTE": _doctorNameGTE,
      if (!isDoctor && _patientNameGTE?.isNotEmpty == true)
        "PatientNameGTE": _patientNameGTE,
      if (!isDoctor && _createdAfter != null)
        "CreatedAfter": _createdAfter!.toIso8601String(),
      if (!isDoctor && _createdBefore != null)
        "CreatedBefore": _createdBefore!.toIso8601String(),
      "isDeleted": true,
    };
    final result = await _reviewProvider.get(filter: filter);

    if (mounted) {
      setState(() {
        _reviews = result.resultList.cast<Review>();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteReview(int reviewId) async {
    final confirmed = await showCustomConfirmDialog(
      context,
      title: "Delete Review",
      text: "Are you sure you want to delete this review?",
      confirmBtnText: "Delete",
      cancelBtnText: "Cancel",
      confirmBtnColor: Colors.red,
    );

    if (confirmed) {
      try {
        await _reviewProvider.delete(reviewId);
        if (mounted) _fetchReviews();
      } catch (e) {
        if (mounted) {
          await showErrorAlert(context, "Failed to delete review.");
        }
      }
    }
  }

  Widget _dateFilterField(
    String label,
    DateTime? value,
    TextEditingController controller,
    ValueChanged<DateTime?> onChange,
    VoidCallback onClear,
  ) {
    return SizedBox(
      width: 120,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                controller.text = DateFormat('dd.MM.yyyy.').format(picked);
                onChange(picked);
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
              ),
              child: Text(
                value != null ? DateFormat('dd.MM.yyyy.').format(value) : '',
              ),
            ),
          ),
          if (value != null)
            Positioned(
              right: 2,
              child: GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.clear, size: 18, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    if (isDoctor) return const SizedBox.shrink();

    return Card(
      color: Colors.blue.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 12, top: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Icon(Icons.filter_alt, color: Colors.blueAccent),
              const SizedBox(width: 10),
              SizedBox(
                width: 150,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Doctor name",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _doctorNameGTE = value;
                      _fetchReviews();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Patient name",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _patientNameGTE = value;
                      _fetchReviews();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              _dateFilterField(
                "From",
                _createdAfter,
                _fromDateController,
                (picked) {
                  setState(() {
                    _createdAfter = picked;
                    _fetchReviews();
                  });
                },
                () {
                  _fromDateController.clear();
                  setState(() {
                    _createdAfter = null;
                    _fetchReviews();
                  });
                },
              ),
              const Text("—"),
              _dateFilterField(
                "To",
                _createdBefore,
                _toDateController,
                (picked) {
                  setState(() {
                    _createdBefore = picked;
                    _fetchReviews();
                  });
                },
                () {
                  _toDateController.clear();
                  setState(() {
                    _createdBefore = null;
                    _fetchReviews();
                  });
                },
              ),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: _selectedRating,
                hint: const Text("Rating"),
                items: List.generate(
                  5,
                  (i) =>
                      DropdownMenuItem(value: i + 1, child: Text("${i + 1}")),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedRating = value;
                    _fetchReviews();
                  });
                },
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedRating = null;
                    _doctorNameGTE = null;
                    _patientNameGTE = null;
                    _createdAfter = null;
                    _createdBefore = null;
                    _fromDateController.clear();
                    _toDateController.clear();
                    _fetchReviews();
                  });
                },
                icon: const Icon(Icons.clear),
                label: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRow(Review r) {
    ImageProvider avatar;
    if (r.patientProfilePicture != null &&
        r.patientProfilePicture!.isNotEmpty &&
        r.patientProfilePicture != "AA==") {
      try {
        avatar = MemoryImage(base64Decode(r.patientProfilePicture!));
      } catch (_) {
        avatar = const AssetImage('assets/images/placeholder.png');
      }
    } else {
      avatar = const AssetImage('assets/images/placeholder.png');
    }

    return Card(
      color: r.isDeleted! ? Colors.grey.shade100 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: r.isDeleted! ? Colors.grey.shade300 : Colors.blue.shade100,
          width: r.isDeleted! ? 1 : 1.5,
        ),
      ),
      elevation: r.isDeleted! ? 1 : 4,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (r.doctorName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "Dr. ${r.doctorName!}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(Icons.star, color: Colors.orange.shade700, size: 24),
                    Text(
                      r.rating?.toString() ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (r.comment != null && r.comment!.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "\"${r.comment!.trim()}\"",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 18),
                      Row(
                        children: [
                          if (r.patientName != null) ...[
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: avatar,
                              backgroundColor: Colors.grey[300],
                            ),
                            const SizedBox(width: 5),
                            Text(
                              r.patientName!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 15),
                          ],
                          Icon(
                            Icons.calendar_today,
                            size: 13,
                            color: Colors.blueGrey.shade300,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            r.createdAt != null
                                ? DateFormat(
                                  'dd.MM.yyyy. HH:mm',
                                ).format(DateTime.parse(r.createdAt!))
                                : "-",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isDoctor) ...[
                  if (r.isDeleted == true)
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Chip(
                        label: Text("Removed"),
                        backgroundColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  if (r.isDeleted != true)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: "Delete review",
                        onPressed: () => _deleteReview(r.reviewId!),
                      ),
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _reviews.isEmpty
                  ? const Center(
                    child: Text(
                      "No reviews found.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: _reviews.length,
                    itemBuilder:
                        (context, index) => _buildReviewRow(_reviews[index]),
                  ),
        ),
      ],
    );
  }
}

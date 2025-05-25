import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/models/review.dart';
import 'package:healthease_mobile/providers/review_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DoctorReviewsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorReviewsScreen({super.key, required this.doctor});

  String formatDateTime(String? dateString) {
    if (dateString == null) return "";
    try {
      final date = DateTime.parse(dateString).toLocal();
      return DateFormat("dd.MM.yyyy. • HH:mm").format(date);
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Reviews for Dr. ${doctor.user?.lastName ?? ""}",
      showBackButton: true,
      currentRoute: "DoctorReviews",
      child: FutureBuilder(
        future: Provider.of<ReviewProvider>(
          context,
          listen: false,
        ).get(filter: {"DoctorId": doctor.doctorId}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load reviews."));
          }
          final reviews =
              (snapshot.data?.resultList as List?)?.cast<Review>() ??
              <Review>[];
          if (reviews.isEmpty) {
            return const Center(
              child: Text(
                "No reviews yet.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final r = reviews[index];
              final isDeleted = r.isDeleted == true;

              ImageProvider patientImage;
              if (r.patientProfilePicture != null &&
                  r.patientProfilePicture!.isNotEmpty &&
                  r.patientProfilePicture != "AA==") {
                try {
                  Uint8List imgBytes = base64Decode(r.patientProfilePicture!);
                  patientImage = MemoryImage(imgBytes);
                } catch (_) {
                  patientImage = const AssetImage(
                    'assets/images/placeholder.png',
                  );
                }
              } else {
                patientImage = const AssetImage(
                  'assets/images/placeholder.png',
                );
              }

              return Opacity(
                opacity: isDeleted ? 0.5 : 1,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  color: isDeleted ? Colors.grey.shade100 : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(backgroundImage: patientImage, radius: 22),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    r.patientName ?? "Anonymous",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                  Text(
                                    r.rating?.toString() ?? "-",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isDeleted)
                                    Chip(
                                      label: const Text("Removed"),
                                      backgroundColor: Colors.grey.shade400,
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatDateTime(r.createdAt),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              if (r.comment != null &&
                                  r.comment!.trim().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "\"${r.comment!.trim()}\"",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/models/review.dart';
import 'package:healthease_mobile/screens/make_appointment_screen.dart';
import 'package:healthease_mobile/screens/doctor_reviews_screen.dart';
import 'package:healthease_mobile/providers/review_provider.dart';
import 'package:provider/provider.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  double _calculateAverageRating(List<Review> reviews) {
    final validReviews =
        reviews
            .where((r) => r.isDeleted != true && (r.rating ?? 0) > 0)
            .toList();
    if (validReviews.isEmpty) return 0.0;
    final sum = validReviews.fold<double>(
      0.0,
      (prev, r) => prev + (r.rating ?? 0),
    );
    return sum / validReviews.length;
  }

  int _countComments(List<Review> reviews) {
    return reviews
        .where(
          (r) =>
              r.isDeleted != true &&
              r.comment != null &&
              r.comment!.trim().isNotEmpty,
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (doctor.user?.profilePicture != null &&
        doctor.user?.profilePicture != "AA==") {
      imageBytes = base64Decode(doctor.user!.profilePicture!);
    }

    final specializations =
        doctor.doctorSpecializations
            ?.map((e) => e.name)
            .whereType<String>()
            .toList()
            .join(', ') ??
        "-";

    return MasterScreen(
      title: "Doctor Info",
      showBackButton: true,
      currentRoute: "DoctorDetails",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFDCE7FF),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        imageBytes != null
                            ? MemoryImage(imageBytes)
                            : const AssetImage('assets/images/placeholder.png')
                                as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${doctor.title ?? ''} ${doctor.user?.firstName ?? ''} ${doctor.user?.lastName ?? ''}, ",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specializations,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // FutureBuilder za reviews!
                  FutureBuilder(
                    future: Provider.of<ReviewProvider>(
                      context,
                      listen: false,
                    ).get(
                      filter: {
                        "DoctorId": doctor.doctorId,
                        // dodaš i isDeleted=false filter ako imaš podršku na backendu
                      },
                    ),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text("Failed to load reviews.");
                      }
                      final reviewList =
                          (snapshot.data?.resultList as List?)
                              ?.cast<Review>() ??
                          <Review>[];
                      final avgRating = _calculateAverageRating(reviewList);
                      final numComments = _countComments(reviewList);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _InfoChip(
                            icon: Icons.star,
                            text: avgRating.toStringAsFixed(1),
                          ),
                          const SizedBox(width: 10),
                          _InfoChip(icon: Icons.reviews, text: "$numComments"),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => DoctorReviewsScreen(doctor: doctor),
                            ),
                          );
                        },
                        icon: const Icon(Icons.reviews),
                        label: const Text("View Reviews"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Coming soon: Send message to doctor!",
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.mail),
                        label: const Text("Send Message"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MakeAppointmentScreen(doctor: doctor),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text("Book an Appointment"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            _Section(
              title: "Details",
              content:
                  doctor.biography?.trim().isNotEmpty == true
                      ? doctor.biography!
                      : "No biography available.",
            ),
            _SectionWithList(
              title: "Specializations",
              items: doctor.doctorSpecializations ?? [],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widgeti ostaju isti:

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label: Text(text),
      backgroundColor: const Color(0xFFF8F9FF),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 6),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _SectionWithList extends StatelessWidget {
  final String title;
  final List<dynamic> items;

  const _SectionWithList({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(items.length, (index) {
            final e = items[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.medical_services,
                      size: 18,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      e.name ?? "Unnamed",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  e.description ?? "No description provided.",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                if (index != items.length - 1) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 10),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}

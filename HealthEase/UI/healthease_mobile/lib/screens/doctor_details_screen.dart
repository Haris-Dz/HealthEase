import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/doctor.dart';
import 'package:healthease_mobile/screens/make_appointment_screen.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (doctor.user?.profilePicture != null &&
        doctor.user?.profilePicture != "AA==") {
      imageBytes = base64Decode(doctor.user!.profilePicture!);
    }

    final workingHours = doctor.workingHours;
    String workingText =
        workingHours != null && workingHours.isNotEmpty
            ? "${workingHours.first.startTime} - ${workingHours.first.endTime}"
            : "Not specified";

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _InfoChip(icon: Icons.access_time, text: workingText),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _InfoChip(icon: Icons.star, text: "5"),
                      SizedBox(width: 10),
                      _InfoChip(icon: Icons.people, text: "40"),
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

const String lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
    "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

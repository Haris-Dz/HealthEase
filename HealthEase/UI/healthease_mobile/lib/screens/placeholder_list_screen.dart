import 'package:flutter/material.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';

class PlaceholderListScreen extends StatelessWidget {
  const PlaceholderListScreen({super.key});

@override
Widget build(BuildContext context) {
  return MasterScreen(
    title: "Placeholder",
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.health_and_safety, size: 60, color: Colors.blue),
          SizedBox(height: 16),
          Text("Welcome to HealthEase!", style: TextStyle(fontSize: 18)),
        ],
      ),
    ),
  );
}
}

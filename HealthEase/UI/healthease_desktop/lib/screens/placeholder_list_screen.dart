import 'package:flutter/material.dart';
import 'package:healthease_desktop/layouts/master_screen.dart';

class PlaceholderListScreen extends StatelessWidget {
  const PlaceholderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Korisnici", // Title for the screen
      child: Container(), // Placeholder or any widget you want to display in the content area
    );
  }
}

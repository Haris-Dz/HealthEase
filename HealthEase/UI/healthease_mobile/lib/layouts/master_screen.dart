import 'package:flutter/material.dart';
import 'package:healthease_mobile/main.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:healthease_mobile/screens/my_profile_screen.dart';
import 'package:healthease_mobile/screens/placeholder_list_screen.dart';

class MasterScreen extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool showBackButton;

  const MasterScreen({
    super.key,
    required this.title,
    required this.child,
    this.backgroundColor,
    this.actions,
    this.showBackButton = false,
  });

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showBackButton ? null : _buildDrawer(context),
      appBar: AppBar(
  backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
  foregroundColor: Colors.white,
  automaticallyImplyLeading: false,
  leading: Builder(
    builder: (context) => IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
    ),
  ),
  title: Text(
    title,
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
  centerTitle: true,
  actions: [
    if (showBackButton)
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ...?actions,
  ],
),

      body: child,
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      width: 240,
      child: Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.nat_sharp),
                  title: const Text("Placeholder"),
                  onTap: () => _navigateTo(context, const PlaceholderListScreen()),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("My Profile"),
                  onTap: () => _navigateTo(context, const MyProfileScreen()),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    final confirmed = await showCustomConfirmDialog(
      context,
      title: "Confirm Logout",
      text: "Are you sure you want to log out?",
      confirmBtnColor: Colors.red,
    );

    if (!confirmed) return;

    AuthProvider.username = null;
    AuthProvider.password = null;
    AuthProvider.userId = null;
    AuthProvider.patientId = null;

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}

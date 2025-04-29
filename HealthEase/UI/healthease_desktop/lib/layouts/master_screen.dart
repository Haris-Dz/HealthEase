import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:healthease_desktop/screens/dashboard_screen.dart';
import 'package:healthease_desktop/screens/doctors_screen.dart';
import 'package:healthease_desktop/screens/users_screen.dart';
import 'package:healthease_desktop/main.dart';

class MasterScreen extends StatefulWidget {
  final String title;
  final Widget child;

  const MasterScreen({super.key, required this.title, required this.child});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  late Widget _currentChild;
  late String _currentTitle;

  @override
  void initState() {
    super.initState();
    _currentChild = widget.child;
    _currentTitle = widget.title;
  }

  void _onSidebarItemTapped(String title, Widget screen) {
    setState(() {
      _currentTitle = title;
      _currentChild = screen;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showCustomConfirmDialog(
      context,
      title: "Confirm Logout",
      text: "Are you sure you want to log out?",
      confirmBtnText: "Logout",
      confirmBtnColor: Colors.red,
    );

    if (confirm) {
      AuthProvider.username = null;
      AuthProvider.password = null;
      AuthProvider.userId = null;
      AuthProvider.userRoles = null;

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged out'),
          duration: Duration(milliseconds: 900),
        ),
      );
    }
  }

  void _showProfileMenu(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, 59, 0, 0),
      items: const [
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.black87),
              SizedBox(width: 10),
              Text('My Profile'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.black87),
              SizedBox(width: 10),
              Text('Logout'),
            ],
          ),
        ),
      ],
      elevation: 8,
    );

    if (selected == 'logout') {
      _logout(context);
    } else if (selected == 'profile') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('My profile selected'),
          duration: Duration(milliseconds: 900),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: Row(
        children: [
          Container(
            width: 240,
            color: const Color(0xFF1976D2),
            child: Column(
              children: [
                const SizedBox(height: 0),
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSidebarItem("Dashboard", Icons.bar_chart, () {
                 _onSidebarItemTapped("Dashboard", const DashboardScreen());
                }),
                _buildSidebarItem("Users", Icons.people, () {
                  _onSidebarItemTapped("Users", const UsersScreen());
                }),
                _buildSidebarItem("Doctors", Icons.health_and_safety_outlined, () {
                  _onSidebarItemTapped("Doctors", const DoctorsScreen());
                }),
                _buildSidebarItem("Recepti", Icons.receipt, () {
                  _onSidebarItemTapped("Recepti", const Placeholder());
                }),
                _buildSidebarItem("Obavještenja", Icons.notifications, () {
                  _onSidebarItemTapped("Obavještenja", const Placeholder());
                }),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text("Logout", style: TextStyle(color: Colors.white)),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 60,
                  color: const Color(0xFF0D47A1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currentTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications, color: Colors.white),
                            onPressed: () {},
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTapDown: (details) => _showProfileMenu(context, details.globalPosition),
                              child: const Icon(Icons.account_circle, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: _currentChild,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

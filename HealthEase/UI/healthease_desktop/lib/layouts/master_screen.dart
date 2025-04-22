import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/screens/doctors_screen.dart';
import 'package:healthease_desktop/screens/users_screen.dart';
import 'package:healthease_desktop/main.dart'; // LoginPage se nalazi u main.dart

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

  void _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Transform.translate(
              offset: const Offset(0, -2),
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Transform.translate(
              offset: const Offset(0, -2),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      AuthProvider.username = null;
      AuthProvider.password = null;
      AuthProvider.userId = null;
      AuthProvider.userRoles = null;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged out'),duration: Duration(milliseconds: 900), ),
      );
    }
  }

void _showProfileMenu(BuildContext context, Offset offset) async {
  final selected = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(offset.dx, 59, 0, 0),
    items: [
      const PopupMenuItem<String>(
        value: 'profile',
        child: Row(
          children: [
            Icon(Icons.person, color: Colors.black87),
            SizedBox(width: 10),
            Text('My Profile'),
          ],
        ),
      ),
      const PopupMenuItem<String>(
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
  ).then((value) {
    if (value == 'logout') {
      _logout(context);
    } else if (value == 'profile') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('My profile selected'),duration: Duration(milliseconds: 900), ),
      );
    }
  });
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
                _buildSidebarItem("Doctors", Icons.health_and_safety_outlined, () {
                  _onSidebarItemTapped("Doctors", DoctorsScreen());
                }),
                _buildSidebarItem("Users", Icons.people, () {
                  _onSidebarItemTapped("Users", const UsersScreen());
                }),
                _buildSidebarItem("Statistika", Icons.bar_chart, () {
                  _onSidebarItemTapped("Statistika", const Placeholder());
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
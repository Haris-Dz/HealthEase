import 'package:flutter/material.dart';
import 'package:healthease_desktop/screens/users_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0), // Tamnija plava pozadina
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            color: const Color(0xFF1976D2), // Svjetlija plava za sidebar
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
                _buildSidebarItem("Users", Icons.people, () {
                  _onSidebarItemTapped("Users", const UsersScreen());
                }),
                _buildSidebarItem("Termini", Icons.event, () {
                  _onSidebarItemTapped("Termini", const Placeholder());
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
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 60,
                  color: const Color(0xFF0D47A1), // Tamnija plava
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
                          IconButton(
                            icon: const Icon(Icons.account_circle, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Content Area
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

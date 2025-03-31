import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  final String title;
  final Widget child;

  // Updated constructor with named parameters
  const MasterScreen({super.key, required this.title, required this.child});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
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
                const SizedBox(height: 2),
                Container(
                  height: 120, // You can adjust the height based on your needs
                  width: double.infinity, // This makes the width expand to the right end
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover, // This ensures the logo fills the container and adjusts its size
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSidebarItem(context, "Korisnici", Icons.people),
                _buildSidebarItem(context, "Termini", Icons.event),
                _buildSidebarItem(context, "Statistika", Icons.bar_chart),
                _buildSidebarItem(context, "Recepti", Icons.receipt),
                _buildSidebarItem(context, "Obavještenja", Icons.notifications),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar - Zaglavlje
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 60,
                  color: const Color(0xFF0D47A1), // Tamnija plava
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
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
                    color: Colors.white, // Svijetla pozadina za bolji kontrast
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        // Navigacija prema odgovarajućem ekranu
      },
    );
  }
}

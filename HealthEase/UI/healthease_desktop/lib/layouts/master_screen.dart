import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:healthease_desktop/screens/appointments_screen.dart';
import 'package:healthease_desktop/screens/chat_details_screen.dart';
import 'package:healthease_desktop/screens/home_screen.dart';
import 'package:healthease_desktop/screens/doctors_screen.dart';
import 'package:healthease_desktop/screens/management_screen.dart';
import 'package:healthease_desktop/screens/medical_records_screen.dart';
import 'package:healthease_desktop/screens/messages_screen.dart';
import 'package:healthease_desktop/screens/my_profile_screen.dart';
import 'package:healthease_desktop/screens/notifications_screen.dart';
import 'package:healthease_desktop/screens/reports_screen.dart';
import 'package:healthease_desktop/screens/reviews_screen.dart';
import 'package:healthease_desktop/screens/users_screen.dart';
import 'package:healthease_desktop/main.dart';

class MasterScreen extends StatefulWidget {
  final String title;
  final Widget child;
  final String currentRoute;

  const MasterScreen({
    super.key,
    required this.title,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  late Widget _currentChild;
  late String _currentTitle;
  late String _currentRoute;
  bool get isAdmin {
    return AuthProvider.userRoles?.any(
          (role) => role.role?.roleName?.toLowerCase() == 'admin',
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentRoute == "Messages") {
      // Prikazujemo poruke sa callbackom
      _currentChild = MessagesScreen(onOpenChat: _openChatDetail);
    } else {
      _currentChild = widget.child;
    }
    _currentTitle = widget.title;
    _currentRoute = widget.currentRoute;
  }

  void _onSidebarItemTapped(String title, Widget screen, String route) {
    if (!mounted) return;

    // Samo za Messages moraš proslijediti callback
    if (route == "Messages") {
      setState(() {
        _currentTitle = title;
        _currentChild = MessagesScreen(onOpenChat: _openChatDetail);
        _currentRoute = route;
      });
    } else {
      setState(() {
        _currentTitle = title;
        _currentChild = screen;
        _currentRoute = route;
      });
    }
  }

  void _openChatDetail(int patientId, String patientName) {
    setState(() {
      _currentTitle = patientName;
      _currentChild = ChatDetailScreen(
        otherId: patientId,
        otherName: patientName,
        onBack: _goBackToMessages,
      );
      _currentRoute = "Messages"; // Ostaje na Messages
    });
  }

  void _goBackToMessages() {
    setState(() {
      _currentTitle = "Messages";
      _currentChild = MessagesScreen(onOpenChat: _openChatDetail);
      _currentRoute = "Messages";
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
      _onSidebarItemTapped("My Profile", const MyProfileScreen(), "My Profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 240,
            color: const Color(0xFF1976D2),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
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
                      _buildSidebarItem(
                        "Home",
                        Icons.home_outlined,
                        const HomeScreen(),
                        "Home",
                      ),
                      _buildSidebarItem(
                        "My Profile",
                        Icons.person,
                        const MyProfileScreen(),
                        "My Profile",
                      ),
                      if (isAdmin) ...[
                        _buildSidebarItem(
                          "Doctors",
                          Icons.health_and_safety_outlined,
                          const DoctorsScreen(),
                          "Doctors",
                        ),
                      ],
                      _buildSidebarItem(
                        "Appointments",
                        Icons.schedule,
                        const AppointmentsScreen(),
                        "Appointments",
                      ),
                      _buildSidebarItem(
                        "Medical records",
                        Icons.medical_services_outlined,
                        const MedicalRecordsScreen(),
                        "Medical records",
                      ),
                      _buildSidebarItem(
                        "Reviews",
                        Icons.rate_review_outlined,
                        const ReviewsScreen(),
                        "Reviews",
                      ),
                      if (isAdmin) ...[
                        _buildSidebarItem(
                          "Users",
                          Icons.people,
                          const UsersScreen(),
                          "Users",
                        ),
                        _buildSidebarItem(
                          "Reports",
                          Icons.insert_chart_outlined,
                          const ReportsScreen(),
                          "Reports",
                        ),
                      ],
                      _buildSidebarItem(
                        "Messages",
                        Icons.message_outlined,
                        MessagesScreen(onOpenChat: _openChatDetail),
                        "Messages",
                      ),
                      if (isAdmin) ...[
                        _buildSidebarItem(
                          "Management",
                          Icons.settings,
                          const ManagementScreen(),
                          "Management",
                        ),
                        _buildSidebarItem(
                          "Notifications Manager",
                          Icons.notifications,
                          const NotificationsScreen(),
                          "Notifications Manager",
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),

          // CONTENT
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
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTapDown:
                                  (details) => _showProfileMenu(
                                    context,
                                    details.globalPosition,
                                  ),
                              child: const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
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

  Widget _buildSidebarItem(
    String title,
    IconData icon,
    Widget screen,
    String route,
  ) {
    final bool isActive = _currentRoute == route;

    return Container(
      color: isActive ? const Color(0xFF0D47A1) : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.8),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.8),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape:
            isActive
                ? const Border(left: BorderSide(color: Colors.white, width: 4))
                : null,
        onTap: () => _onSidebarItemTapped(title, screen, route),
      ),
    );
  }
}

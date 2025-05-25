import 'package:flutter/material.dart';
import 'package:healthease_mobile/main.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:healthease_mobile/providers/notifications_provider.dart';
import 'package:healthease_mobile/screens/appointments_screen.dart';
import 'package:healthease_mobile/screens/doctors_screen.dart';
import 'package:healthease_mobile/screens/favorites_screen.dart';
import 'package:healthease_mobile/screens/messages_screen.dart';
import 'package:healthease_mobile/screens/my_profile_screen.dart';
import 'package:healthease_mobile/screens/notifications_screen.dart';
import 'package:healthease_mobile/screens/payments_screen.dart';
import 'package:healthease_mobile/screens/placeholder_screen.dart';

class MasterScreen extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool showBackButton;
  final String currentRoute;

  const MasterScreen({
    super.key,
    required this.title,
    required this.child,
    required this.currentRoute,
    this.backgroundColor,
    this.actions,
    this.showBackButton = false,
  });

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => screen,
        settings: RouteSettings(name: screen.runtimeType.toString()),
      ),
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
        titleSpacing: 0,
        title: Row(
          children: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(showBackButton ? Icons.arrow_back : Icons.menu),
                    onPressed: () {
                      if (showBackButton) {
                        Navigator.of(context).pop();
                      } else {
                        Scaffold.of(context).openDrawer();
                      }
                    },
                  ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        actions: actions,
      ),
      body: child,
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required Widget screen,
    required String currentRoute,
    bool showNotificationBadge = false,
  }) {
    final isActive = currentRoute == route;

    Widget leadingIcon = Icon(
      icon,
      color: isActive ? Colors.blue : Colors.black,
      size: isActive ? 28 : 24,
    );

    if (showNotificationBadge) {
      leadingIcon = Stack(
        clipBehavior: Clip.none,
        children: [
          leadingIcon,
          Positioned(
            right: -6,
            top: -6,
            child: FutureBuilder<int>(
              future: NotificationsProvider()
                  .get(
                    filter: {
                      "PatientId": AuthProvider.patientId,
                      "IsRead": false,
                    },
                    retrieveAll: true,
                  )
                  .then((res) => res.resultList.length),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == 0) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${snapshot.data}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return ListTile(
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: leadingIcon,
      ),
      title: Text(title),
      tileColor: isActive ? Colors.blue.shade100 : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape:
          isActive
              ? const Border(left: BorderSide(color: Colors.blue, width: 4))
              : null,
      onTap: () {
        if (!isActive) {
          Navigator.pop(context);
          _navigateTo(context, screen);
        }
      },
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
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                Container(color: Colors.blue.withOpacity(0.3)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.local_hospital_outlined,
                  title: "Doctors",
                  route: "Doctors",
                  screen: const DoctorsScreen(),
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.favorite_border,
                  title: "Favorites",
                  route: "Favorites",
                  screen: const FavoritesScreen(),
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.schedule,
                  title: "Appointments",
                  route: "Appointments",
                  screen: const AppointmentsScreen(),
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.medical_information_outlined,
                  title: "Medical Record",
                  route: "Medical Record",
                  screen: const PlaceholderScreen(),
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.mail_outlined,
                  title: "Messages",
                  route: "Messages",
                  screen: const MessagesScreen(),
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.payment,
                  title: "Payments",
                  route: "Payments",
                  screen: const PaymentsScreen(),
                  currentRoute: currentRoute,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.notifications_none_outlined,
                  title: "Notifications",
                  route: "Notifications",
                  screen: const NotificationsScreen(),
                  currentRoute: currentRoute,
                  showNotificationBadge: true,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.account_circle_outlined,
                  title: "My Profile",
                  route: "My Profile",
                  screen: const MyProfileScreen(),
                  currentRoute: currentRoute,
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

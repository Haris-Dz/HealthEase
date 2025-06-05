import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/app_notification.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/notifications_provider.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationsProvider _notificationsProvider;
  late Future<List<AppNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsProvider = Provider.of<NotificationsProvider>(
      context,
      listen: false,
    );
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    _notificationsFuture = _notificationsProvider
        .get(
          filter: {"PatientId": AuthProvider.patientId},
          retrieveAll: true,
          orderBy: "CreatedAt",
          sortDirection: "desc",
        )
        .then((res) => res.resultList);
    setState(() {});
  }

  Future<void> _markAsRead(int id) async {
    try {
      await _notificationsProvider.markAsRead(id);
      await _loadNotifications();
    } catch (e) {
      await showErrorAlert(context, "Failed to mark as read.");
    }
  }

  Future<void> _deleteNotification(int id) async {
    try {
      await _notificationsProvider.delete(id);
      await showSuccessAlert(context, "Notification deleted.");
      await _loadNotifications();
    } catch (e) {
      await showErrorAlert(context, "Failed to delete notification.");
    }
  }

  String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  Widget buildNotificationCard(AppNotification n, bool isUnread) {
    return Slidable(
      key: Key(n.notificationId.toString()),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) async {
              final confirm = await showCustomConfirmDialog(
                context,
                title: "Confirm Delete",
                text: "Are you sure you want to delete this notification?",
                confirmBtnColor: Colors.red,
              );
              if (confirm) {
                await _deleteNotification(n.notificationId!);
              }
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          if (isUnread) {
            await _markAsRead(n.notificationId!);
          }
        },
        child: Card(
          elevation: 2,
          color: isUnread ? Colors.grey.shade300 : Colors.grey.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(n.message ?? "-"),
            subtitle: Text(
              n.createdAt != null
                  ? formatRelativeTime(DateTime.parse(n.createdAt!))
                  : "-",
            ),
            trailing: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Notifications",
      currentRoute: "Notifications",
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<AppNotification>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Failed to load notifications"));
            }

            final notifications = snapshot.data ?? [];

            final unread =
                notifications.where((n) => n.isRead != true).toList();
            final read = notifications.where((n) => n.isRead == true).toList();

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_outlined, size: 72),
                    const SizedBox(height: 16),
                    const Text(
                      "No notifications",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _loadNotifications,
              child: ListView(
                children: [
                  if (unread.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "New",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ...unread.map((n) => buildNotificationCard(n, true)),
                  if (read.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Older",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ...read.map((n) => buildNotificationCard(n, false)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

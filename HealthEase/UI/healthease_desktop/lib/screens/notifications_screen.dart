import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/app_notification.dart';
import 'package:healthease_desktop/models/patient.dart';
import 'package:healthease_desktop/providers/notifications_provider.dart';
import 'package:healthease_desktop/providers/patients_provider.dart';
import 'package:healthease_desktop/models/search_result.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _searchUsernameController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late NotificationsProvider _notificationsProvider;
  late Future<SearchResult<AppNotification>> _notificationsFuture;

  Patient? _selectedPatient;
  bool _sendToAll = false;

  // Autocomplete key for resetting
  Key _autocompleteKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _notificationsProvider = Provider.of<NotificationsProvider>(
      context,
      listen: false,
    );
    _loadNotifications();
  }

  void _loadNotifications() {
    _notificationsFuture = _notificationsProvider.get(
      filter: {
        if (_searchUsernameController.text.isNotEmpty)
          'UsernameGTE': _searchUsernameController.text,
      },
      orderBy: "CreatedAt",
      sortDirection: "desc",
    );
    setState(() {});
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _notificationsProvider.insert({
        if (!_sendToAll) 'patientId': _selectedPatient!.patientId,
        'message': _messageController.text.trim(),
      });

      await showSuccessAlert(context, "Notification sent successfully.");

      setState(() {
        _messageController.clear();
        _selectedPatient = null;
        _formKey.currentState!.reset();
        _autocompleteKey = UniqueKey(); // resetuje Autocomplete
      });

      _loadNotifications();
    } catch (e) {
      await showErrorAlert(context, "Failed to send notification.");
    }
  }

  Widget _buildSearchBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: TextField(
            controller: _searchUsernameController,
            decoration: const InputDecoration(
              labelText: 'Search by Username',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (_) => _loadNotifications(),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: _loadNotifications,
          icon: const Icon(Icons.search),
          label: const Text('Search'),
        ),
      ],
    );
  }

  Widget _buildSendNotificationCard() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Send Notification",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _sendToAll,
                    onChanged: (value) {
                      setState(() {
                        _sendToAll = value!;
                        if (_sendToAll) {
                          _selectedPatient = null;
                          _autocompleteKey = UniqueKey();
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Send to all patients //TODO (RabbitMQ)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormField<bool>(
                    validator: (_) {
                      if (!_sendToAll && _selectedPatient == null) {
                        return 'Please select a patient or enable "Send to all".';
                      }
                      return null;
                    },
                    builder: (state) {
                      return Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Autocomplete<Patient>(
                              key: _autocompleteKey,
                              optionsBuilder: (TextEditingValue value) async {
                                if (value.text.length < 2) {
                                  return const Iterable<Patient>.empty();
                                }
                                final provider = Provider.of<PatientsProvider>(
                                  context,
                                  listen: false,
                                );
                                final result = await provider.get(
                                  filter: {"UsernameGTE": value.text},
                                  retrieveAll: true,
                                );
                                return result.resultList;
                              },
                              displayStringForOption:
                                  (Patient p) => p.username ?? '',
                              onSelected: (Patient p) {
                                setState(() {
                                  _selectedPatient = p;
                                });
                              },
                              fieldViewBuilder: (
                                context,
                                controller,
                                focusNode,
                                onEditingComplete,
                              ) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  enabled: !_sendToAll,
                                  decoration: const InputDecoration(
                                    labelText: "Search patient by username",
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: 20,
                              child:
                                  state.hasError
                                      ? Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(
                                          state.errorText!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _messageController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Message is required.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Message",
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _sendNotification,
                    icon: const Icon(Icons.send),
                    label: const Text("Send"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(SearchResult<AppNotification> result) {
    if (result.resultList.isEmpty) {
      return const Center(child: Text("No notifications found."));
    }

    return ListView.builder(
      itemCount: result.resultList.length,
      itemBuilder: (context, index) {
        final notification = result.resultList[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(notification.message ?? ''),
            subtitle: Text("username: ${notification.patient!.username ?? ""}"),
            trailing: Text(
              notification.createdAt != null
                  ? formatDateString(notification.createdAt!)
                  : "-",
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildSendNotificationCard(),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<SearchResult<AppNotification>>(
            future: _notificationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              final result = snapshot.data!;
              return _buildNotificationsList(result);
            },
          ),
        ),
      ],
    );
  }
}

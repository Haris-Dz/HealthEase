import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/message.dart';
import 'package:healthease_desktop/models/patient.dart';
import 'package:healthease_desktop/providers/messages_provider.dart';
import 'package:healthease_desktop/providers/patients_provider.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/screens/chat_details_screen.dart';

class MessagesScreen extends StatefulWidget {
  final void Function(int patientId, String patientName)? onOpenChat;

  const MessagesScreen({super.key, this.onOpenChat});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late MessagesProvider _messagesProvider;
  late PatientsProvider _patientsProvider;
  bool _isLoading = true;
  bool _isPatientsLoading = true;
  List<Message> _latestMessages = [];
  List<Patient> _allPatients = [];
  Patient? _selectedPatient;

  @override
  void initState() {
    super.initState();
    _messagesProvider = MessagesProvider();
    _patientsProvider = PatientsProvider();
    _fetchPatients();
    _fetchLatestMessages();
  }

  Future<void> _fetchPatients() async {
    setState(() => _isPatientsLoading = true);
    final result = await _patientsProvider.get(retrieveAll: true);
    setState(() {
      _allPatients = result.resultList;
      _isPatientsLoading = false;
    });
  }

  Future<void> _fetchLatestMessages() async {
    setState(() => _isLoading = true);

    final result = await _messagesProvider.get(
      filter: {"UserId": AuthProvider.userId},
      retrieveAll: true,
      orderBy: "sentAt",
      sortDirection: "desc",
    );

    Map<int, Message> chatMap = {};
    for (var msg in result.resultList) {
      final int? chatKey = msg.patientId;
      if (chatKey == null) continue;
      if (!chatMap.containsKey(chatKey)) {
        chatMap[chatKey] = msg;
      } else {
        if (DateTime.parse(
          msg.sentAt ?? "",
        ).isAfter(DateTime.parse(chatMap[chatKey]!.sentAt ?? ""))) {
          chatMap[chatKey] = msg;
        }
      }
    }
    _latestMessages =
        chatMap.values.toList()..sort(
          (a, b) => DateTime.parse(
            b.sentAt ?? "",
          ).compareTo(DateTime.parse(a.sentAt ?? "")),
        );

    setState(() => _isLoading = false);
  }

  void _openChat(Patient patient) {
    if (widget.onOpenChat != null) {
      widget.onOpenChat!(
        patient.patientId!,
        "${patient.firstName ?? ""} ${patient.lastName ?? ""}".trim(),
      );
    } else {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder:
                  (_) => ChatDetailScreen(
                    otherId: patient.patientId!,
                    otherName:
                        "${patient.firstName ?? ""} ${patient.lastName ?? ""}"
                            .trim(),
                  ),
            ),
          )
          .then((_) => _fetchLatestMessages());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child:
              _isPatientsLoading
                  ? const LinearProgressIndicator()
                  : Row(
                    children: [
                      Expanded(
                        child: Autocomplete<Patient>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return _allPatients;
                            }
                            return _allPatients.where(
                              (Patient p) =>
                                  (p.firstName ?? '').toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ) ||
                                  (p.lastName ?? '').toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ),
                            );
                          },
                          displayStringForOption:
                              (Patient p) =>
                                  "${p.firstName ?? ''} ${p.lastName ?? ''}"
                                      .trim(),
                          fieldViewBuilder: (
                            context,
                            controller,
                            focusNode,
                            onEditingComplete,
                          ) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: "Send new message to...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.search),
                                isDense: true,
                              ),
                              onEditingComplete: onEditingComplete,
                            );
                          },
                          onSelected: (Patient selected) {
                            _openChat(selected);
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                child: Container(
                                  width: 350,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: options.length,
                                    itemBuilder: (context, index) {
                                      final Patient option = options.elementAt(
                                        index,
                                      );
                                      return ListTile(
                                        title: Text(
                                          "${option.firstName ?? ''} ${option.lastName ?? ''}",
                                        ),
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
        ),
        const Divider(height: 1),
        Expanded(
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _latestMessages.isEmpty
                  ? const Center(child: Text("No conversations yet."))
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _latestMessages.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) {
                      final msg = _latestMessages[index];
                      final displayName =
                          "${msg.patient?.firstName ?? ''} ${msg.patient?.lastName ?? ''}"
                              .trim();
                      final profilePic = msg.patient?.profilePicture;
                      final subtitle =
                          msg.isDeleted == true
                              ? "Message deleted"
                              : (msg.content != null && msg.content!.length > 64
                                  ? "${msg.content!.substring(0, 64)}..."
                                  : msg.content ?? "");

                      final unread =
                          !(msg.isRead ?? true) &&
                          !(msg.senderType == "User" &&
                              msg.senderId == AuthProvider.userId);

                      return ListTile(
                        leading:
                            (profilePic == null || profilePic == "AA==")
                                ? const CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(
                                    'assets/images/placeholder.png',
                                  ),
                                )
                                : CircleAvatar(
                                  radius: 24,
                                  backgroundImage: MemoryImage(
                                    base64Decode(
                                      profilePic.replaceAll(
                                        RegExp(r'data:image/[^;]+;base64,'),
                                        '',
                                      ),
                                    ),
                                  ),
                                ),
                        title: Text(
                          displayName.isNotEmpty ? displayName : "Patient",
                          style: TextStyle(
                            fontWeight:
                                unread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          subtitle,
                          style:
                              msg.isDeleted == true
                                  ? const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                        trailing:
                            unread
                                ? Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.markunread,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                                : null,
                        onTap: () {
                          final otherId = msg.patientId!;
                          final otherName =
                              displayName.isNotEmpty ? displayName : "Patient";
                          if (widget.onOpenChat != null) {
                            widget.onOpenChat!(otherId, otherName);
                          } else {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ChatDetailScreen(
                                          otherId: otherId,
                                          otherName: otherName,
                                        ),
                                  ),
                                )
                                .then((_) => _fetchLatestMessages());
                          }
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

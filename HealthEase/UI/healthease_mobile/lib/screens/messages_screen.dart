import 'package:flutter/material.dart';
import 'package:healthease_mobile/models/message.dart';
import 'package:healthease_mobile/providers/messages_provider.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'dart:convert';

import 'package:healthease_mobile/screens/chat_details_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late MessagesProvider _messagesProvider;
  bool _isLoading = true;
  List<Message> _latestMessages = [];

  @override
  void initState() {
    super.initState();
    _messagesProvider = MessagesProvider();
    _fetchLatestMessages();
  }

  Future<void> _fetchLatestMessages() async {
    setState(() => _isLoading = true);

    final result = await _messagesProvider.get(
      filter: {"PatientId": AuthProvider.patientId},
      retrieveAll: true,
      orderBy: "sentAt",
      sortDirection: "desc",
    );

    Map<int, Message> chatMap = {};
    for (var msg in result.resultList) {
      final int? chatKey = msg.userId;
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

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Messages",
      currentRoute: "Messages",
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _latestMessages.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.message_outlined, size: 72),
                    const SizedBox(height: 16),
                    const Text(
                      "No conversations yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _latestMessages.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final msg = _latestMessages[index];

                  final displayName =
                      "${msg.user?.firstName ?? ''} ${msg.user?.lastName ?? ''}";
                  final profilePic = msg.user?.profilePicture;

                  final subtitle =
                      msg.isDeleted == true
                          ? "Message deleted"
                          : (msg.content != null && msg.content!.length > 64
                              ? "${msg.content!.substring(0, 64)}..."
                              : msg.content ?? "");

                  final unread =
                      !(msg.isRead ?? true) &&
                      !(msg.senderType == "Patient" &&
                          msg.senderId == AuthProvider.patientId);

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
                      displayName.trim().isNotEmpty ? displayName : "Doctor",
                      style: TextStyle(
                        fontWeight:
                            unread ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(subtitle),
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
                    onTap: () async {
                      final otherId = msg.userId;
                      final otherName =
                          displayName.trim().isNotEmpty
                              ? displayName
                              : "Doctor";

                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => ChatDetailScreen(
                                otherId: otherId!,
                                otherName: otherName,
                              ),
                        ),
                      );
                      _fetchLatestMessages();
                    },
                  );
                },
              ),
    );
  }
}

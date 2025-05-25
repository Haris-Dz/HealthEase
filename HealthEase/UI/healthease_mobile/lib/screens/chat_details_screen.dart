import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthease_mobile/models/message.dart';
import 'package:healthease_mobile/providers/messages_provider.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/providers/utils.dart';

class ChatDetailScreen extends StatefulWidget {
  final int otherId;
  final String otherName;

  const ChatDetailScreen({
    super.key,
    required this.otherId,
    required this.otherName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late MessagesProvider _messagesProvider;
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _messagesProvider = MessagesProvider();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    setState(() => _isLoading = true);

    final filter = {
      "UserId": widget.otherId,
      "PatientId": AuthProvider.patientId,
    };

    final result = await _messagesProvider.get(
      filter: filter,
      retrieveAll: true,
      orderBy: "sentAt",
      sortDirection: "asc",
    );

    _messages = result.resultList;
    setState(() => _isLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final content = _msgController.text.trim();
    if (content.isEmpty) return;

    final insertReq = {
      "patientId": AuthProvider.patientId,
      "userId": widget.otherId,
      "senderId": AuthProvider.patientId,
      "senderType": "Patient",
      "content": content,
    };

    try {
      await _messagesProvider.insert(insertReq);
      _msgController.clear();
      _fetchMessages();
    } catch (e) {
      await showErrorAlert(context, "Failed to send message.");
    }
  }

  Future<void> _deleteMessage(int messageId, int index) async {
    try {
      await _messagesProvider.delete(messageId);

      setState(() {
        _messages[index].isDeleted = true;
      });

      await showSuccessAlert(context, "Message deleted.");
    } catch (_) {
      await showErrorAlert(context, "Failed to delete message!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: widget.otherName,
      currentRoute: "Messages",
      showBackButton: true,
      child: Column(
        children: [
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _messages.isEmpty
                    ? const Center(child: Text("No messages yet."))
                    : ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isMe =
                            msg.senderType == "Patient" &&
                            msg.senderId == AuthProvider.patientId;
                        final profilePic =
                            !isMe ? msg.user?.profilePicture : null;
                        final displayName =
                            !isMe ? (msg.user?.firstName ?? '') : '';

                        final messageBubble = Align(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 320),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color:
                                      isMe
                                          ? Colors.blue[200]
                                          : Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft:
                                        isMe
                                            ? const Radius.circular(16)
                                            : const Radius.circular(0),
                                    bottomRight:
                                        isMe
                                            ? const Radius.circular(0)
                                            : const Radius.circular(16),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!isMe)
                                        Row(
                                          children: [
                                            (profilePic == null ||
                                                    profilePic == "AA==")
                                                ? const CircleAvatar(
                                                  radius: 12,
                                                  backgroundImage: AssetImage(
                                                    'assets/images/placeholder.png',
                                                  ),
                                                )
                                                : CircleAvatar(
                                                  radius: 12,
                                                  backgroundImage: MemoryImage(
                                                    base64Decode(
                                                      profilePic.replaceAll(
                                                        RegExp(
                                                          r'data:image/[^;]+;base64,',
                                                        ),
                                                        '',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            const SizedBox(width: 4),
                                            Text(
                                              displayName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (!isMe) const SizedBox(height: 2),
                                      msg.isDeleted == true
                                          ? Text(
                                            "Message deleted",
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          )
                                          : Text(
                                            msg.content ?? "",
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),

                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          _formatTime(msg.sentAt),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                        if (isMe && msg.isDeleted != true) {
                          return Dismissible(
                            key: Key('msg_${msg.messageId}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await showCustomConfirmDialog(
                                context,
                                title: "Delete message",
                                text:
                                    "Are you sure you want to delete this message?",
                                confirmBtnText: "Delete",
                                cancelBtnText: "Cancel",
                                confirmBtnColor: Colors.red,
                              );
                            },
                            onDismissed: (_) async {
                              await _deleteMessage(msg.messageId!, index);
                            },
                            child: messageBubble,
                          );
                        } else {
                          return messageBubble;
                        }
                      },
                    ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    textInputAction: TextInputAction.send,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? sentAt) {
    if (sentAt == null) return '';
    try {
      final dt = DateTime.parse(sentAt).toLocal();
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return '';
    }
  }
}

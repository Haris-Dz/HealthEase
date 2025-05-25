import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/message.dart';
import 'package:healthease_desktop/providers/messages_provider.dart';
import 'package:healthease_desktop/providers/auth_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';

class ChatDetailScreen extends StatefulWidget {
  final int otherId;
  final String otherName;
  final VoidCallback? onBack;

  const ChatDetailScreen({
    super.key,
    required this.otherId,
    required this.otherName,
    this.onBack,
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

    final filter = {"UserId": AuthProvider.userId, "PatientId": widget.otherId};
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
      "patientId": widget.otherId,
      "userId": AuthProvider.userId,
      "senderId": AuthProvider.userId,
      "senderType": "User",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button odmah ispod AppBara (bez paddinga)
        Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 8),
          child: Container(
            width: 56,
            height: 48,
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF0D47A1),
                size: 32,
              ),
              onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
            ),
          ),
        ),
        const SizedBox(height: 10),
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
                          msg.senderType == "User" &&
                          msg.senderId == AuthProvider.userId;
                      return _buildMessageBubble(isMe, msg, index);
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
    );
  }

  Widget _buildMessageBubble(bool isMe, Message msg, int index) {
    final profilePic = !isMe ? msg.patient?.profilePicture : null;
    final displayName = !isMe ? (msg.patient?.firstName ?? '') : '';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[200] : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    isMe ? const Radius.circular(16) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Row(
                      children: [
                        (profilePic == null || profilePic == "AA==")
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
                                    RegExp(r'data:image/[^;]+;base64,'),
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
                      ? const Text(
                        "Message deleted",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      )
                      : Text(
                        msg.content ?? "",
                        style: const TextStyle(fontSize: 15),
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(msg.sentAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                      if (isMe && msg.isDeleted != true)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Tooltip(
                            message: "Delete message",
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                final confirm = await showCustomConfirmDialog(
                                  context,
                                  title: "Delete message",
                                  text:
                                      "Are you sure you want to delete this message?",
                                  confirmBtnText: "Delete",
                                  cancelBtnText: "Cancel",
                                  confirmBtnColor: Colors.red,
                                );
                                if (confirm == true) {
                                  await _deleteMessage(msg.messageId!, index);
                                }
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red[50],
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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

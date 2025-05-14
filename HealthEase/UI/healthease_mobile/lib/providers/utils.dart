import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');
  if (dynamic == null) {
    return "";
  }
  return f.format(dynamic);
}

String formatDate(DateTime date) {
  return DateFormat('dd.MM.yyyy.').format(date);
}

String formatDateString(String? dateString) {
  if (dateString == null || dateString.isEmpty) return '-';
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd.MM.yyyy.').format(date);
  } catch (e) {
    return '-';
  }
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

Future<bool> showCustomConfirmDialog(
  BuildContext context, {
  required String title,
  required String text,
  String confirmBtnText = 'Yes',
  String cancelBtnText = 'No',
  Color confirmBtnColor = Colors.green,
  Color cancelBorderColor = Colors.grey,
}) async {
  if (!context.mounted) return false;
  bool confirmed = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(text, style: const TextStyle(color: Colors.black)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: 110,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  confirmed = false;
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: cancelBorderColor, width: 1.5),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(cancelBtnText),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  confirmed = true;
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmBtnColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(confirmBtnText),
              ),
            ),
          ],
        ),
  );

  return confirmed;
}

Future<void> showSuccessAlert(BuildContext context, String message) async {
  if (!context.mounted) return;
  await QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: "Success",
    text: message,
  );
}

Future<void> showErrorAlert(BuildContext context, String message) async {
  if (!context.mounted) return;
  await QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: "Error",
    text: message,
  );
}

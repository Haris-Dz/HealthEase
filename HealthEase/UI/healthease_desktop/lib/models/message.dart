import 'package:healthease_desktop/models/patient.dart';
import 'package:healthease_desktop/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

@JsonSerializable()
class Message {
  int? messageId;
  int? patientId;
  int? userId;
  int? senderId;
  String? content;
  String? sentAt;
  String? senderType;
  bool? isRead;
  bool? isDeleted;
  User? user;
  Patient? patient;

  Message();

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

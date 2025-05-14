import 'package:healthease_mobile/models/appointment.dart';
import 'package:healthease_mobile/models/patient.dart';
import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  int? transactionId;
  double? amount;
  String? transactionDate;
  String? paymentMethod;
  String? paymentId;
  String? payerId;
  int? patientId;
  int? appointmentId;
  Patient? patient;
  Appointment? appointment;

  Transaction();

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

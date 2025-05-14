// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) =>
    Transaction()
      ..transactionId = (json['transactionId'] as num?)?.toInt()
      ..amount = (json['amount'] as num?)?.toDouble()
      ..transactionDate = json['transactionDate'] as String?
      ..paymentMethod = json['paymentMethod'] as String?
      ..paymentId = json['paymentId'] as String?
      ..payerId = json['payerId'] as String?
      ..patientId = (json['patientId'] as num?)?.toInt()
      ..appointmentId = (json['appointmentId'] as num?)?.toInt()
      ..patient =
          json['patient'] == null
              ? null
              : Patient.fromJson(json['patient'] as Map<String, dynamic>)
      ..appointment =
          json['appointment'] == null
              ? null
              : Appointment.fromJson(
                json['appointment'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'transactionDate': instance.transactionDate,
      'paymentMethod': instance.paymentMethod,
      'paymentId': instance.paymentId,
      'payerId': instance.payerId,
      'patientId': instance.patientId,
      'appointmentId': instance.appointmentId,
      'patient': instance.patient,
      'appointment': instance.appointment,
    };

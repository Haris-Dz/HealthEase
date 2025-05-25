// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminReportSummary _$AdminReportSummaryFromJson(Map<String, dynamic> json) =>
    AdminReportSummary(
      totalAppointments: (json['totalAppointments'] as num).toInt(),
      approvedAppointments: (json['approvedAppointments'] as num).toInt(),
      declinedAppointments: (json['declinedAppointments'] as num).toInt(),
      pendingAppointments: (json['pendingAppointments'] as num).toInt(),
      paidAppointments: (json['paidAppointments'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      revenuePerMonth:
          (json['revenuePerMonth'] as List<dynamic>)
              .map((e) => RevenuePerMonth.fromJson(e as Map<String, dynamic>))
              .toList(),
      topDoctorsByAppointments:
          (json['topDoctorsByAppointments'] as List<dynamic>)
              .map((e) => TopDoctor.fromJson(e as Map<String, dynamic>))
              .toList(),
      topDoctorsByRating:
          (json['topDoctorsByRating'] as List<dynamic>)
              .map((e) => TopDoctor.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      averageDoctorRating: (json['averageDoctorRating'] as num).toDouble(),
    );

Map<String, dynamic> _$AdminReportSummaryToJson(
  AdminReportSummary instance,
) => <String, dynamic>{
  'totalAppointments': instance.totalAppointments,
  'approvedAppointments': instance.approvedAppointments,
  'declinedAppointments': instance.declinedAppointments,
  'pendingAppointments': instance.pendingAppointments,
  'paidAppointments': instance.paidAppointments,
  'totalRevenue': instance.totalRevenue,
  'revenuePerMonth': instance.revenuePerMonth.map((e) => e.toJson()).toList(),
  'topDoctorsByAppointments':
      instance.topDoctorsByAppointments.map((e) => e.toJson()).toList(),
  'topDoctorsByRating':
      instance.topDoctorsByRating.map((e) => e.toJson()).toList(),
  'totalReviews': instance.totalReviews,
  'averageDoctorRating': instance.averageDoctorRating,
};

RevenuePerMonth _$RevenuePerMonthFromJson(Map<String, dynamic> json) =>
    RevenuePerMonth(
      month: json['month'] as String,
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$RevenuePerMonthToJson(RevenuePerMonth instance) =>
    <String, dynamic>{'month': instance.month, 'revenue': instance.revenue};

TopDoctor _$TopDoctorFromJson(Map<String, dynamic> json) => TopDoctor(
  doctorId: (json['doctorId'] as num).toInt(),
  name: json['name'] as String,
  appointmentsCount: (json['appointmentsCount'] as num).toInt(),
  averageRating: (json['averageRating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TopDoctorToJson(TopDoctor instance) => <String, dynamic>{
  'doctorId': instance.doctorId,
  'name': instance.name,
  'appointmentsCount': instance.appointmentsCount,
  'averageRating': instance.averageRating,
};

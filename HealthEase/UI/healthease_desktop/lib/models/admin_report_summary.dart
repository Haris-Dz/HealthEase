import 'package:json_annotation/json_annotation.dart';

part 'admin_report_summary.g.dart';

@JsonSerializable(explicitToJson: true)
class AdminReportSummary {
  final int totalAppointments;
  final int approvedAppointments;
  final int declinedAppointments;
  final int pendingAppointments;
  final int paidAppointments;
  final double totalRevenue;
  final List<RevenuePerMonth> revenuePerMonth;
  final List<TopDoctor> topDoctorsByAppointments;
  final List<TopDoctor> topDoctorsByRating;
  final int totalReviews;
  final double averageDoctorRating;

  AdminReportSummary({
    required this.totalAppointments,
    required this.approvedAppointments,
    required this.declinedAppointments,
    required this.pendingAppointments,
    required this.paidAppointments,
    required this.totalRevenue,
    required this.revenuePerMonth,
    required this.topDoctorsByAppointments,
    required this.topDoctorsByRating,
    required this.totalReviews,
    required this.averageDoctorRating,
  });

  factory AdminReportSummary.fromJson(Map<String, dynamic> json) =>
      _$AdminReportSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AdminReportSummaryToJson(this);
}

@JsonSerializable()
class RevenuePerMonth {
  final String month;
  final double revenue;

  RevenuePerMonth({required this.month, required this.revenue});

  factory RevenuePerMonth.fromJson(Map<String, dynamic> json) =>
      _$RevenuePerMonthFromJson(json);

  Map<String, dynamic> toJson() => _$RevenuePerMonthToJson(this);
}

@JsonSerializable()
class TopDoctor {
  final int doctorId;
  final String name;
  final int appointmentsCount;
  final double? averageRating;

  TopDoctor({
    required this.doctorId,
    required this.name,
    required this.appointmentsCount,
    this.averageRating,
  });

  factory TopDoctor.fromJson(Map<String, dynamic> json) =>
      _$TopDoctorFromJson(json);

  Map<String, dynamic> toJson() => _$TopDoctorToJson(this);
}

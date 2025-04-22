import 'package:json_annotation/json_annotation.dart';

part 'working_hours.g.dart';

@JsonSerializable()
class WorkingHours {
  int? workingHoursId;
  int? day;
  String? startTime;
  String? endTime;

  WorkingHours();

  factory WorkingHours.fromJson(Map<String, dynamic> json) =>
      _$WorkingHoursFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingHoursToJson(this);
}

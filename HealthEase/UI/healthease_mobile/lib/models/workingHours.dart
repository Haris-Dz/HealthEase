import 'package:json_annotation/json_annotation.dart';
part 'workingHours.g.dart';

@JsonSerializable()
class WorkingHours {
  int? workingHoursId;
  int? day;
  String? startTime;
  String? endTime;


  WorkingHours();

  factory WorkingHours.fromJson(Map<String, dynamic> json) =>
      _$WorkingHoursFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$WorkingHoursToJson(this);
}
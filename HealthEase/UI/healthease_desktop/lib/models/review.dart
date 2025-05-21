import 'package:json_annotation/json_annotation.dart';
part 'review.g.dart';

@JsonSerializable()
class Review {
  int? reviewId;
  int? doctorId;
  int? appointmentId;
  int? patientId;
  double? rating;
  String? comment;
  String? createdAt;
  String? doctorName;
  String? patientName;
  String? patientProfilePicture;
  bool? isDeleted;

  Review();

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

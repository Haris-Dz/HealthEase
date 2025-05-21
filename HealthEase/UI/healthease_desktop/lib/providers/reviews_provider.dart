import 'package:healthease_desktop/models/review.dart';
import 'package:healthease_desktop/providers/base_provider.dart';

class ReviewsProvider extends BaseProvider<Review> {
  ReviewsProvider() : super("Review");

  @override
  Review fromJson(data) {
    // TODO: implement fromJson
    return Review.fromJson(data);
  }
}

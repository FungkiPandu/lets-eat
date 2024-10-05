import 'dart:convert';

import 'package:lets_eat/data/models/customer_review.dart';

class CustomerReviewResponse {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  CustomerReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory CustomerReviewResponse.fromRawJson(String str) => CustomerReviewResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerReviewResponse.fromJson(Map<String, dynamic> json) => CustomerReviewResponse(
    error: json["error"],
    message: json["message"],
    customerReviews: List<CustomerReview>.from(json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "customerReviews": List<dynamic>.from(customerReviews.map((x) => x.toJson())),
  };
}
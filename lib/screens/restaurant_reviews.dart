import 'package:flutter/material.dart';
import 'package:lets_eat/data/models/customer_review.dart';
import 'package:lets_eat/widgets/customer_review_item_list.dart';

class RestaurantReviews extends StatelessWidget {
  final List<CustomerReview> reviews;

  const RestaurantReviews({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reviews")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: reviews
            .map(
              (e) => CustomerReviewItemList(review: e),
            )
            .toList(),
      ),
    );
  }
}

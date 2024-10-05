import 'package:flutter/material.dart';
import 'package:lets_eat/data/models/customer_review.dart';

class CustomerReviewItemList extends StatelessWidget {
  final CustomerReview review;

  const CustomerReviewItemList({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.name, style: Theme.of(context).textTheme.titleMedium),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: Text(review.review),
                ),
                Text(
                  review.date,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final double rate;
  final double? size;
  final bool hideText;

  const Rating({
    super.key,
    required this.rate,
    this.size,
    this.hideText = false,
  });

  @override
  Widget build(BuildContext context) {
    final roundRating = (rate * 2).round();
    return Row(
      children: [
        Row(
          children: List.generate(
            5,
            (index) {
              if (roundRating > index * 2) {
                if (roundRating >= (index + 1) * 2) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: size,
                  );
                }
                return Icon(
                  Icons.star_half,
                  color: Colors.amber,
                  size: size,
                );
              }
              return Icon(
                Icons.star_border,
                color: Colors.amber,
                size: size,
              );
            },
          ),
        ),
        if (!hideText) const SizedBox(width: 6),
        if (!hideText)
          Text("($rate)", style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

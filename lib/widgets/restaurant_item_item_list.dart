import 'package:flutter/material.dart';
import 'package:lets_eat/data/models/item.dart';

class RestaurantItemItemList extends StatelessWidget {
  final Item item;
  final ItemType itemType;

  const RestaurantItemItemList({
    super.key,
    required this.item,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width - 20 * 2;
    final responsiveWidth = w / (w / 200).ceil();
    return Container(
      width: responsiveWidth, // grid item width size
      padding: const EdgeInsets.all(4),
      child: Card(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  itemType == ItemType.food
                      ? "assets/food.png"
                      : "assets/beverage.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

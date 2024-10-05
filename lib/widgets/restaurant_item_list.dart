import 'package:flutter/material.dart';
import 'package:lets_eat/data/api/api_service.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/widgets/rating.dart';

class RestaurantItemList extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantItemList(
      {super.key, required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                      child: Hero(
                        tag: restaurant.pictureId,
                        child: Image.network(
                          ApiService.getRestaurantPictureUrl(
                            restaurant,
                            size: PictureSize.small,
                          ),
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, e, s) => Image.asset(
                            width: 140,
                            fit: BoxFit.cover,
                            "assets/restaurant.png",
                            errorBuilder: (context, e, s) => Container(
                              width: 140,
                              color: Colors.orange.shade200,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Rating(rate: restaurant.rating, size: 20),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.place_rounded,
                            color: Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.city,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

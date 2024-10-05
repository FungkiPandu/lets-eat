import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_eat/bloc/get_restaurant_detail/get_restaurant_detail_cubit.dart';
import 'package:lets_eat/bloc/restaurant_favorites/restaurant_favorites_cubit.dart';
import 'package:lets_eat/data/api/api_service.dart';
import 'package:lets_eat/data/models/item.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/helpers/database.dart';
import 'package:lets_eat/helpers/string.dart';
import 'package:lets_eat/screens/restaurant_reviews.dart';
import 'package:lets_eat/widgets/collapsible_text.dart';
import 'package:lets_eat/widgets/customer_review_item_list.dart';
import 'package:lets_eat/widgets/error_view.dart';
import 'package:lets_eat/widgets/rating.dart';
import 'package:lets_eat/widgets/restaurant_item_item_list.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  final apiService = ApiService();
  final db = DatabaseHelper();

  late GetRestaurantDetailCubit getRestaurantDetailCubit;
  late RestaurantFavoritesCubit restaurantFavoritesCubit;

  Restaurant? restaurantDetail;
  bool? _isFavorited;

  @override
  void initState() {
    super.initState();
    getRestaurantDetailCubit = GetRestaurantDetailCubit(apiService: apiService);
    restaurantFavoritesCubit = RestaurantFavoritesCubit(db);
    super.initState();
    getRestaurantDetailCubit.getRestaurantDetail(widget.restaurant.id);
    restaurantFavoritesCubit.getIsFavorited(widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          header,
          detail,
          ratingAndReviews,
          menuHeader,
          menu,
        ],
      ),
    );
  }

  Widget get header => SliverLayoutBuilder(
        builder: (BuildContext context, constraints) {
          final scrolled = constraints.scrollOffset > 0;
          return SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.restaurant.pictureId,
                child: Image.network(
                  ApiService.getRestaurantPictureUrl(
                    widget.restaurant,
                    size: PictureSize.large,
                  ),
                  fit: BoxFit.cover,
                  errorBuilder: (context, e, s) => Image.asset(
                    fit: BoxFit.cover,
                    "assets/restaurant.png",
                    errorBuilder: (context, e, s) => Container(
                      color: Colors.orange.shade200,
                    ),
                  ),
                ),
              ),
              title: Text(
                widget.restaurant.name,
                style: TextStyle(color: !scrolled ? Colors.white : null),
              ),
            ),
            leading: BackButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (!scrolled) {
                      return Colors.white.withOpacity(0.5);
                    }
                    return null;
                  },
                ),
              ),
            ),
          );
        },
      );

  Widget get detail => SliverToBoxAdapter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurant.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.place_rounded,
                                  color: Colors.grey,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(widget.restaurant.city),
                              ],
                            ),
                          ],
                        ),
                      ),
                      BlocListener<RestaurantFavoritesCubit,
                          RestaurantFavoritesState>(
                        bloc: restaurantFavoritesCubit,
                        listener: (context, state) {
                          if (state is RestaurantFavoriteStateChanged) {
                            setState(() {
                              _isFavorited = state.isFavorited;
                            });
                            // do a refresh to favorite list
                            BlocProvider.of<RestaurantFavoritesCubit>(context)
                                .getFavoriteList();
                          }
                        },
                        child: FloatingActionButton(
                          onPressed: () {
                            if (_isFavorited == null) return;
                            if (_isFavorited == true) {
                              restaurantFavoritesCubit
                                  .removeFavorite(widget.restaurant);
                            } else {
                              restaurantFavoritesCubit
                                  .addFavorite(widget.restaurant);
                            }
                          },
                          child: Icon(
                            _isFavorited == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  CollapsibleText(text: widget.restaurant.description),
                ],
              ),
            ),
          ],
        ),
      );

  Widget get ratingAndReviews => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              Text(
                "Rating and Reviews",
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        widget.restaurant.rating.toString(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Rating(
                          rate: widget.restaurant.rating,
                          size: 16,
                          hideText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  BlocBuilder<GetRestaurantDetailCubit,
                      GetRestaurantDetailState>(
                    bloc: getRestaurantDetailCubit,
                    builder: (context, state) {
                      if (state is GetRestaurantDetailError) {
                        return Expanded(
                          child: Center(
                              child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(width: 8),
                              Text(state.message),
                            ],
                          )),
                        );
                      }
                      if (state is GetRestaurantDetailSuccess) {
                        if (state.restaurant.customerReviews?.isNotEmpty ??
                            false) {
                          final total =
                              state.restaurant.customerReviews!.length;
                          return Expanded(
                            child: Column(
                              children: [
                                CustomerReviewItemList(
                                  review:
                                      state.restaurant.customerReviews!.first,
                                ),
                                if (total > 1)
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => RestaurantReviews(
                                            reviews: state
                                                .restaurant.customerReviews!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("See more reviews ($total)"),
                                  )
                                else
                                  const SizedBox(height: 6),
                              ],
                            ),
                          );
                        }
                        return const Expanded(
                          child: Center(
                            child: Text("No reviews yet"),
                          ),
                        );
                      }
                      return const Expanded(
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      );

  Widget get menuHeader => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
          child: Column(
            children: [
              Text(
                "Menus",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // const Divider(),
            ],
          ),
        ),
      );

  Widget get menu => BlocBuilder(
        bloc: getRestaurantDetailCubit,
        builder: (context, state) {
          if (state is GetRestaurantDetailError) {
            return SliverToBoxAdapter(
              child: ErrorView(
                message: state.message,
                onRetryPressed: () {
                  getRestaurantDetailCubit
                      .getRestaurantDetail(widget.restaurant.id);
                },
              ),
            );
          }
          if (state is GetRestaurantDetailSuccess) {
            return SliverList.list(
              children: (state.restaurant.menus?.toJson().entries ?? [])
                  .map(
                    (menu) => [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
                        child: Text(
                          menu.key.toTitleCase(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: List.generate(
                            menu.value.length,
                            (index) {
                              return RestaurantItemItemList(
                                item: Item.fromJson(menu.value[index]),
                                itemType: menu.key == "foods"
                                    ? ItemType.food
                                    : ItemType.beverage,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                  .expand((e) => e)
                  .toList(),
            );
          }
          return const SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );
}

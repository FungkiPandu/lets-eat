import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_eat/bloc/restaurant_favorites/restaurant_favorites_cubit.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/screens/restaurant_detail_page.dart';
import 'package:lets_eat/widgets/error_view.dart';
import 'package:lets_eat/widgets/restaurant_item_list.dart';

class RestaurantFavoritesPage extends StatefulWidget {
  static const routeName = '/restaurant_favorites';

  const RestaurantFavoritesPage({super.key});

  @override
  State<RestaurantFavoritesPage> createState() =>
      _RestaurantFavoritesPageState();
}

class _RestaurantFavoritesPageState extends State<RestaurantFavoritesPage> {
  List<Restaurant> _restaurants = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RestaurantFavoritesCubit>(context).getFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorites"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Confirmation"),
                  content:
                      const Text("Are you sure to clear your favorite list?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        BlocProvider.of<RestaurantFavoritesCubit>(context)
                            .clearFavoriteFromList();
                        Navigator.pop(context);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_sweep),
          ),
        ],
      ),
      body: BlocConsumer<RestaurantFavoritesCubit, RestaurantFavoritesState>(
        listener: (context, state) {
          if (state is RestaurantFavoriteList) {
            setState(() {
              _restaurants = state.restaurants;
            });
          }
        },
        builder: (context, state) {
          var restaurants = _restaurants;
          if (state is RestaurantFavoriteList) {
            restaurants = state.restaurants;
          }
          if (restaurants.isEmpty) {
            return const SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: ErrorView(
                      message: "There is no favorite restaurant yet.\n"
                          "Tap on the ♡ button to mark it as your favorite!",
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 32),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return Dismissible(
                onDismissed: (direction) {
                  BlocProvider.of<RestaurantFavoritesCubit>(context)
                      .removeFavoriteFromList(restaurant);
                },
                key: UniqueKey(),
                child: RestaurantItemList(
                  restaurant: restaurant,
                  onTap: () {
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); //remove focus
                    Navigator.pushNamed(
                      context,
                      RestaurantDetailPage.routeName,
                      arguments: restaurant,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

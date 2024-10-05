import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_eat/bloc/get_restaurants/get_restaurants_cubit.dart';
import 'package:lets_eat/data/api/api_service.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/screens/restaurant_detail_page.dart';
import 'package:lets_eat/screens/restaurant_favorites_page.dart';
import 'package:lets_eat/screens/settings_page.dart';
import 'package:lets_eat/widgets/error_view.dart';
import 'package:lets_eat/widgets/restaurant_item_list.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final apiService = ApiService();
  late GetRestaurantsCubit getRestaurantsCubit;

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _showClearQueryButton = false;
  bool _isScrolled = false;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getRestaurantsCubit.getRestaurants(query: query);
    });
    if (_searchController.text.isNotEmpty && !_showClearQueryButton) {
      setState(() {
        _showClearQueryButton = true;
      });
    } else if (_searchController.text.isEmpty && _showClearQueryButton) {
      setState(() {
        _showClearQueryButton = false;
      });
    }
  }

  @override
  void initState() {
    getRestaurantsCubit = GetRestaurantsCubit(apiService: apiService);
    super.initState();
    getRestaurantsCubit.getRestaurants();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      setState(() {
        _isScrolled = offset > 16 && offset < maxScrollExtent - 16;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Eat!"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text("Preferences"),
                  ],
                ),
              ),
            ],
            onSelected: (v) {
              if (v == 1) {
                Navigator.pushNamed(context, SettingsPage.routeName);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, RestaurantFavoritesPage.routeName);
        },
        extendedPadding: const EdgeInsets.all(16),
        label: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isScrolled ? 32 : 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite),
                if (!_isScrolled) const SizedBox(width: 8),
                if (!_isScrolled)
                  const Expanded(
                    child: FittedBox(
                      child: Text(
                        "My Favorites",
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
              ],
            )),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: SearchBar(
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                leading: const Icon(Icons.search),
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: "Type anything to search",
                hintStyle: const WidgetStatePropertyAll(
                  TextStyle(color: Colors.grey),
                ),
                trailing: [
                  if (_showClearQueryButton)
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                        getRestaurantsCubit.getRestaurants();
                        setState(() {
                          _showClearQueryButton = false;
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                ],
                autoFocus: false,
              ),
            ),
          ),
          BlocBuilder<GetRestaurantsCubit, GetRestaurantsState>(
            bloc: getRestaurantsCubit,
            builder: (context, state) {
              if (state is GetRestaurantsSuccess) {
                final List<Restaurant> restaurants = state.restaurants;
                if (restaurants.isEmpty) {
                  if (state.searchQuery.isNotEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "No restaurants found with `${state.searchQuery}` query.\nPlease try different query!",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                }
                return SliverList.list(
                  children: List.generate(
                    restaurants.length,
                    (index) {
                      final restaurant = restaurants[index];
                      return RestaurantItemList(
                        restaurant: restaurants[index],
                        onTap: () {
                          FocusScope.of(context)
                              .requestFocus(FocusNode()); //remove focus
                          Navigator.pushNamed(
                            context,
                            RestaurantDetailPage.routeName,
                            arguments: restaurant,
                          );
                        },
                      );
                    },
                  ),
                );
              } else if (state is GetRestaurantsError) {
                return SliverToBoxAdapter(
                  child: ErrorView(
                    message: state.message,
                    onRetryPressed: () {
                      getRestaurantsCubit.getRestaurants(
                          query: state.searchQuery);
                    },
                  ),
                );
              }
              return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 128),
          ),
        ],
      ),
    );
  }
}

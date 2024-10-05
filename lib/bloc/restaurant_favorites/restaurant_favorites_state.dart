part of 'restaurant_favorites_cubit.dart';

sealed class RestaurantFavoritesState extends Equatable {
  const RestaurantFavoritesState();
}

final class RestaurantFavoritesInitial extends RestaurantFavoritesState {
  @override
  List<Object> get props => [];
}

final class RestaurantFavoriteStateChanged extends RestaurantFavoritesState {
  final Restaurant restaurant;
  final bool isFavorited;

  const RestaurantFavoriteStateChanged({
    required this.restaurant,
    required this.isFavorited,
  });

  @override
  List<Object> get props => [restaurant, isFavorited];
}

final class RestaurantFavoriteList extends RestaurantFavoritesState {
  final List<Restaurant> restaurants;

  const RestaurantFavoriteList({
    required this.restaurants,
  });

  @override
  List<Object> get props => [restaurants];
}

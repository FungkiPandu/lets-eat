import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/helpers/database.dart';

part 'restaurant_favorites_state.dart';

class RestaurantFavoritesCubit extends Cubit<RestaurantFavoritesState> {
  final DatabaseHelper db;
  RestaurantFavoritesCubit(this.db) : super(RestaurantFavoritesInitial());

  Future<void> getIsFavorited(Restaurant restaurant) async {
    final list = await db.getFavRestaurant(restaurant.id);
    emit(RestaurantFavoriteStateChanged(restaurant: restaurant, isFavorited: list.isNotEmpty));
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    await db.insertFavRestaurant(restaurant);
    getIsFavorited(restaurant);
  }

  Future<void> removeFavorite(Restaurant restaurant) async {
    await db.deleteFavRestaurant(restaurant.id);
    getIsFavorited(restaurant);
  }

  Future<void> removeFavoriteFromList(Restaurant restaurant) async {
    await db.deleteFavRestaurant(restaurant.id);
    getFavoriteList();
  }

  Future<void> clearFavoriteFromList() async {
    await db.clearFavRestaurant();
    getFavoriteList();
  }

  Future<void> getFavoriteList() async {
    final list = await db.getAllFavRestaurants();
    emit(RestaurantFavoriteList(restaurants: list));
  }

}

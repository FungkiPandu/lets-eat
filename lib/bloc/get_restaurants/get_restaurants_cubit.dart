import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lets_eat/data/api/api_service.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/data/models/restaurants_response.dart';

part 'get_restaurants_state.dart';

class GetRestaurantsCubit extends Cubit<GetRestaurantsState> {
  final ApiService apiService;

  GetRestaurantsCubit({required this.apiService})
      : super(GetRestaurantsInitial());

  Future<void> getRestaurants({String query = ""}) async {
    emit(GetRestaurantsLoading());
    try {
      RestaurantsResponse response = await (query.isNotEmpty
          ? apiService.searchRestaurants(query)
          : apiService.getRestaurants());
      emit(GetRestaurantsSuccess(
        restaurants: response.restaurants,
        searchQuery: query,
      ));
    } on SocketException {
      emit(GetRestaurantsError(
        message: "No internet connection",
        searchQuery: query,
      ));
    } on TimeoutException {
      emit(GetRestaurantsError(
        message: "Request timed out",
        searchQuery: query,
      ));
    } catch (e) {
      print(e);
      emit(GetRestaurantsError(
        message: "Unable to fetch data",
        searchQuery: query,
      ));
    }
  }
}

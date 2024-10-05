import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lets_eat/data/api/api_service.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/data/models/restaurant_response.dart';

part 'get_restaurant_detail_state.dart';

class GetRestaurantDetailCubit extends Cubit<GetRestaurantDetailState> {
  final ApiService apiService;

  GetRestaurantDetailCubit({required this.apiService})
      : super(GetRestaurantDetailInitial());

  Future<void> getRestaurantDetail(String id) async {
    emit(GetRestaurantDetailLoading());
    try {
      RestaurantResponse response = await apiService.getRestaurantDetail(id);
      emit(GetRestaurantDetailSuccess(restaurant: response.restaurant));
    } on SocketException {
      emit(const GetRestaurantDetailError(message: "No internet connection"));
    } on TimeoutException {
      emit(const GetRestaurantDetailError(message: "Request timed out"));
    } catch (e) {
      emit(const GetRestaurantDetailError(message: "Unable to fetch data"));
    }
  }
}

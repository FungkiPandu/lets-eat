part of 'get_restaurants_cubit.dart';

sealed class GetRestaurantsState extends Equatable {
  const GetRestaurantsState();
}

final class GetRestaurantsInitial extends GetRestaurantsState {
  @override
  List<Object> get props => [];
}

final class GetRestaurantsLoading extends GetRestaurantsState {
  @override
  List<Object> get props => [];
}

final class GetRestaurantsSuccess extends GetRestaurantsState {
  final List<Restaurant> restaurants;
  final String searchQuery;

  const GetRestaurantsSuccess({
    required this.restaurants,
    required this.searchQuery,
  });

  @override
  List<Object> get props => [searchQuery, restaurants];
}

final class GetRestaurantsError extends GetRestaurantsState {
  final String message;
  final String searchQuery;

  const GetRestaurantsError({
    required this.message,
    required this.searchQuery,
  });

  @override
  List<Object> get props => [message, searchQuery];
}

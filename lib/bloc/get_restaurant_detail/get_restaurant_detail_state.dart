part of 'get_restaurant_detail_cubit.dart';

sealed class GetRestaurantDetailState extends Equatable {
  const GetRestaurantDetailState();
}

final class GetRestaurantDetailInitial extends GetRestaurantDetailState {
  @override
  List<Object> get props => [];
}

final class GetRestaurantDetailLoading extends GetRestaurantDetailState {
  @override
  List<Object> get props => [];
}

final class GetRestaurantDetailSuccess extends GetRestaurantDetailState {
  final Restaurant restaurant;

  const GetRestaurantDetailSuccess({required this.restaurant});

  @override
  List<Object> get props => [restaurant];
}

final class GetRestaurantDetailError extends GetRestaurantDetailState {
  final String message;

  const GetRestaurantDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

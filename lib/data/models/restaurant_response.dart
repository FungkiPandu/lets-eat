import 'dart:convert';

import 'package:lets_eat/data/api/api_service.dart';
import 'package:lets_eat/data/models/restaurant.dart';

class RestaurantResponse {
  bool error;
  String message;
  Restaurant restaurant;

  RestaurantResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantResponse.fromRawJson(String str) =>
      RestaurantResponse.fromJson(
        json.decode(str),
      );

  String toRawJson() => json.encode(toJson());

  factory RestaurantResponse.fromJson(
    Map<String, dynamic> json, {
    ApiService? apiService,
  }) =>
      RestaurantResponse(
        error: json["error"],
        message: json["message"],
        restaurant: Restaurant.fromJson(
          json["restaurant"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}

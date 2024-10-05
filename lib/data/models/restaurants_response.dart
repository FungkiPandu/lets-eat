import 'dart:convert';

import 'package:lets_eat/data/api/api_service.dart';
import 'package:lets_eat/data/models/restaurant.dart';

class RestaurantsResponse {
  bool error;
  String message;
  int count;
  int founded;
  List<Restaurant> restaurants;

  RestaurantsResponse({
    required this.error,
    this.message = "",
    this.count = 0,
    this.founded = 0,
    required this.restaurants,
  });

  factory RestaurantsResponse.fromRawJson(String str,
          {ApiService? apiService}) =>
      RestaurantsResponse.fromJson(
        json.decode(str),
        apiService: apiService,
      );

  String toRawJson() => json.encode(toJson());

  factory RestaurantsResponse.fromJson(
    Map<String, dynamic> json, {
    ApiService? apiService,
  }) =>
      RestaurantsResponse(
        error: json["error"],
        message: json["message"] ?? "",
        count: json["count"] ?? 0,
        founded: json["founded"] ?? 0,
        restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "count": count,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

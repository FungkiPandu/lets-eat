import 'package:http/http.dart' as http;
import 'package:lets_eat/data/models/customer_review_response.dart';
import 'package:lets_eat/data/models/restaurant.dart';
import 'package:lets_eat/data/models/restaurant_response.dart';
import 'package:lets_eat/data/models/restaurants_response.dart';

enum PictureSize { small, medium, large }

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String _picturePath = "$_baseUrl/images";

  static String getPicturePath(String id, {PictureSize size = PictureSize.medium}) =>
      "$_picturePath/${size.name}/$id";

  static String getRestaurantPictureUrl(Restaurant restaurant,
          {PictureSize size = PictureSize.medium}) =>
      "$_picturePath/${size.name}/${restaurant.pictureId}";

  Future<RestaurantsResponse> getRestaurants() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));
    if (response.statusCode == 200) {
      return RestaurantsResponse.fromRawJson(
        response.body,
        apiService: this,
      );
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<RestaurantsResponse> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));
    if (response.statusCode == 200) {
      return RestaurantsResponse.fromRawJson(
        response.body,
        apiService: this,
      );
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantResponse.fromRawJson(response.body);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<CustomerReviewResponse> addCustomerReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      headers: {"Content-Type": "application/json"},
      body: {"id": id, "name": name, "review": review},
    );
    if (response.statusCode == 200) {
      return CustomerReviewResponse.fromRawJson(response.body);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }
}

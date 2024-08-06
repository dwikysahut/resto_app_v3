import 'package:resto_app/model/detail_restaurant.dart';

class DetailRestaurantResult {
  final bool error;
  final String message;

  final DetailRestaurant restaurant;

  DetailRestaurantResult({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory DetailRestaurantResult.fromJson(Map<String, dynamic> json) =>
      DetailRestaurantResult(
        error: json['error'],
        message: json['message'],
        restaurant: DetailRestaurant.fromJson(json['restaurant']),
      );
}

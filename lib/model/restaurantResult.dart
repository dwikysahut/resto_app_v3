import 'package:resto_app/model/restaurant.dart';

class RestaurantResult {
  final bool error;
  final String? message;
  final int? count;
  final int? founded;
  final List<Restaurant> restaurants;

  RestaurantResult({
    required this.error,
    required this.message,
    this.count,
    this.founded,
    required this.restaurants,
  });

  factory RestaurantResult.fromJson(Map<String, dynamic> json) =>
      RestaurantResult(
        error: json['error'],
        message: json['message'] ?? '',
        count: json['count'] ?? 0,
        founded: json['founded'] ?? 0,
        restaurants: List<Restaurant>.from(
            (json['restaurants'] as List<dynamic>)
                .map((item) => Restaurant.fromJson(item))).toList(),
      );
}

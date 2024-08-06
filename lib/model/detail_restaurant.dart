import 'package:resto_app/model/restaurant.dart';

class DetailRestaurant {
  final String id;
  final String name;
  final String pictureId;
  final String description;
  final String city;
  final double rating;
  final Menu? menus;

  DetailRestaurant({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.description,
    required this.city,
    required this.rating,
    required this.menus,
  });

  factory DetailRestaurant.fromJson(Map<String, dynamic> json) =>
      DetailRestaurant(
        id: json['id'],
        name: json['name'],
        pictureId: json['pictureId'],
        city: json['city'],
        description: json['description'],
        rating: (json['rating'] as num).toDouble(),
        menus: Menu.fromJson(json['menus']),
      );
}

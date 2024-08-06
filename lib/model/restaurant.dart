import 'dart:convert';

class Restaurant {
  final String id;
  final String name;
  final String pictureId;
  final String description;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.description,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json['id'],
        name: json['name'],
        pictureId: json['pictureId'],
        city: json['city'],
        description: json['description'],
        rating: (json['rating'] as num).toDouble(),
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'pictureId': pictureId,
        'description': description,
        'city': city,
        'rating': rating,
      };
}

List<Restaurant> parseRestaurants(String? json) {
  if (json == null) return [];

  final Map<String, dynamic> data = jsonDecode(json);
  final List restaurantsJson = data['restaurants'];

  return restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
}

class Food {
  final String name;
  Food({
    required this.name,
  });
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        name: json['name'],
      );
}

class Drink {
  final String name;
  Drink({
    required this.name,
  });
  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
        name: json['name'],
      );
}

class Menu {
  final List<Food> foods;
  final List<Food> drinks;
  Menu({
    required this.foods,
    required this.drinks,
  });
  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        foods: List<Food>.from((json['foods'] as List<dynamic>)
            .map((item) => Food.fromJson(item))).toList(),
        drinks: List<Food>.from((json['drinks'] as List<dynamic>)
            .map((item) => Food.fromJson(item))).toList(),
      );
}

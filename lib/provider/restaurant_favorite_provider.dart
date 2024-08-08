import 'package:flutter/foundation.dart';
import 'package:resto_app/data/db/database_helper.dart';
import 'package:resto_app/model/detail_restaurant.dart';
import 'package:resto_app/model/restaurant.dart';
import 'package:resto_app/utils/enum.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavoriteRestaurants();
    if (_favorites.length > 0) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavorite(DetailRestaurant detailRestaurant) async {
    final Restaurant restaurant = Restaurant(
        id: detailRestaurant.id,
        city: detailRestaurant.city,
        description: detailRestaurant.description,
        name: detailRestaurant.name,
        pictureId: detailRestaurant.pictureId,
        rating: detailRestaurant.rating);
    try {
      await databaseHelper.insertToFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getRestaurantById(id);

    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeRestaurantById(id);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}

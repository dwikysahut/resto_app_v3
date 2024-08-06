import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:resto_app/model/restaurantResult.dart';
import 'package:resto_app/service/api_service.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantProvider extends ChangeNotifier {
  final Apiservice apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurants();
  }

  late RestaurantResult _restaurantResult;
  late ResultState _state;
  String _message = '';
  String _query = '';

  //getter
  String get message => _message;
  RestaurantResult get result => _restaurantResult;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.fetchSearchRestaurants(_query);
      if (response.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantResult = response;
      }
    } on ClientException {
      _state = ResultState.error;
      _message = "terjadi Kesalahan, Periksa Koneksi Anda";
      notifyListeners();

      return _message;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  void onSearch(String query) {
    _query = query;
    _fetchAllRestaurants();
  }

  Future<dynamic> onClickSearchHandler(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.fetchSearchRestaurants(query);
      if (response.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantResult = response;
      }
    } on ClientException {
      _state = ResultState.error;
      _message = "terjadi Kesalahan, Periksa Koneksi Anda";
      notifyListeners();

      return _message;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}

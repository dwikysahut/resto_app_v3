import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:resto_app/model/detail_restaurant_result.dart';
import 'package:resto_app/service/api_service.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final Apiservice apiService;
  final String restaurantId;

  RestaurantDetailProvider(
      {required this.apiService, required this.restaurantId}) {
    _fetchRestaurantById();
  }

  late DetailRestaurantResult _restaurantResult;
  late ResultState _state;
  String _message = '';

  //getter
  String get message => _message;
  DetailRestaurantResult get result => _restaurantResult;
  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantById() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.fetchDetailRestaurant(restaurantId);
      _state = ResultState.hasData;
      notifyListeners();
      return _restaurantResult = response;
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

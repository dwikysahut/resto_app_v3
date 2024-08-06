import 'dart:convert';

import 'package:resto_app/model/restaurantResult.dart';
import 'package:http/http.dart' as http;
import 'package:resto_app/model/detail_restaurant_result.dart';
import 'package:resto_app/utils/constant.dart';

class Apiservice {
  Future<RestaurantResult> fetchAllRestaurants() async {
    final response = await http.get(Uri.parse('${Constant.baseUrl}/list'));
    if (response.statusCode == 200) {
      print('berhasil');
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data Restaurants');
    }
  }

  Future<DetailRestaurantResult> fetchDetailRestaurant(String id) async {
    final response =
        await http.get(Uri.parse('${Constant.baseUrl}/detail/$id'));
    if (response.statusCode == 200) {
      print('berhasil 1 ');
      return DetailRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data Restaurants');
    }
  }

  Future<RestaurantResult> fetchSearchRestaurants(String query) async {
    final response =
        await http.get(Uri.parse('${Constant.baseUrl}/search?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data Restaurants');
    }
  }
}

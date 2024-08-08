import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:resto_app/model/restaurant.dart';
import 'package:resto_app/provider/restaurant_provider.dart';
import 'package:resto_app/service/api_service.dart';
import 'package:mockito/mockito.dart';

import 'restaurant_mock_test.dart';

@GenerateMocks([RestaurantProvider, Apiservice])
void main() {
  group('Restaurant Test', () {
    late Restaurant restaurant;
    // late Apiservice apiService;
    // late RestaurantProvider restaurantProvider;

    setUp(() {
      // apiService = MockApiService();
      // restaurantProvider = MockRestaurantProvider();
      restaurant = Restaurant(
          id: "a123",
          name: 'name',
          pictureId: '1',
          description: 'lorem ipsum',
          city: 'malang',
          rating: 4.2);
    });

    test('should be success to parsing json', () {
      var result = Restaurant.fromJson(restaurant.toJson());
      expect(result.name, restaurant.name);
      expect(result.id, restaurant.id);
      expect(result.city, restaurant.city);
    });
  });
}

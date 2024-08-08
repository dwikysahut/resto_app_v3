import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/model/detail_restaurant.dart';
import 'package:resto_app/model/restaurant.dart';
import 'package:resto_app/provider/restaurant_detail_provider.dart';
import 'package:resto_app/provider/restaurant_favorite_provider.dart';
import 'package:resto_app/service/api_service.dart';
import 'package:resto_app/utils/Colors.dart';
import 'package:resto_app/utils/constant.dart';
import 'package:resto_app/utils/enum.dart';

class DetailScreen extends StatelessWidget {
  final String restaurantId;

  const DetailScreen({Key? key, required this.restaurantId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestaurantDetailProvider>(
        create: (_) => RestaurantDetailProvider(
            apiService: Apiservice(), restaurantId: restaurantId),
        child: Scaffold(
            backgroundColor: AppColors.main,
            body: Consumer<RestaurantDetailProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == ResultState.hasData) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FloatingTitle(restaurant: state.result.restaurant),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.bg,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 12.0,
                                          ),
                                          Text(
                                            state.result.restaurant.rating
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      state.result.restaurant.description,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 7.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.main,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.restaurant_menu_outlined,
                                            color: Colors.orange,
                                            size: 12.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Menu Makanan dan Minuman',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.bg),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: ListView.builder(
                                itemCount:
                                    state.result.restaurant.menus?.foods.length,
                                itemBuilder: (context, index) {
                                  final restaurantItem =
                                      state.result.restaurant.menus?.foods ??
                                          [];
                                  return MenuItem<Food>(
                                    restaurant: state.result.restaurant,
                                    restaurantItem: restaurantItem ?? [],
                                    index: index,
                                  );
                                },
                                // This next line does the trick.
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: ListView.builder(
                                itemCount: state
                                    .result.restaurant.menus?.drinks.length,
                                itemBuilder: (context, index) {
                                  final restaurantItem =
                                      state.result.restaurant.menus?.drinks ??
                                          [];
                                  return MenuItem<Food>(
                                    restaurant: state.result.restaurant,
                                    restaurantItem: restaurantItem ?? [],
                                    index: index,
                                  );
                                },
                                // This next line does the trick.
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                        Positioned(
                          top: 225,
                          right: 30,
                          child: Consumer<RestaurantDetailProvider>(
                              builder: (context, stateDetail, _) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: AppColors.bg,
                                    border: Border.all(
                                        width: 0.8, color: AppColors.bg),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Consumer<DatabaseProvider>(
                                    builder: (context, provider, _) {
                                  return FutureBuilder<bool>(
                                      future:
                                          provider.isFavorited(restaurantId),
                                      builder: (context, snapshot) {
                                        var isFavorited =
                                            snapshot.data ?? false;
                                        if (isFavorited) {
                                          return IconButton(
                                            color: AppColors.main,
                                            icon: const Icon(Icons.favorite),
                                            onPressed: () {
                                              provider
                                                  .removeFavorite(restaurantId);
                                            },
                                          );
                                        } else {
                                          return IconButton(
                                            color: AppColors.main,
                                            icon: const Icon(
                                              Icons.favorite_outline,
                                              color: AppColors.main,
                                            ),
                                            onPressed: () {
                                              provider.addFavorite(stateDetail
                                                  .result.restaurant);
                                            },
                                          );
                                        }
                                      });
                                }));
                          }),
                        )
                      ],
                    ),
                  );
                } else if (state.state == ResultState.noData) {
                  return Center(
                    child: Material(
                      child: Text(state.message),
                    ),
                  );
                } else if (state.state == ResultState.error) {
                  return Center(
                    child: Material(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return const Center(
                    child: Material(
                      child: Text(''),
                    ),
                  );
                }
              },
            )));
  }
}

class MenuItem<T> extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.restaurant,
    required this.restaurantItem,
    required this.index,
  });

  final DetailRestaurant restaurant;
  final List<Food> restaurantItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      height: 120,
      child: Stack(
        children: [
          // Gambar dengan Hero untuk animasi
          Positioned(
            right: 30,
            top: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: const Icon(
                Icons.menu_book,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          // Kotak di atas gambar
          Positioned(
            bottom: 2, // Posisi atas dari kotak
            left: 8, // Posisi kiri dari kotak
            right: 8, //
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantItem[index].name.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Rp.15.000"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingTitle extends StatelessWidget {
  const FloatingTitle({
    super.key,
    required this.restaurant,
  });

  final DetailRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gambar dengan Hero untuk animasi
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Hero(
            tag: restaurant.pictureId,
            child: Image.network(
              '${Constant.baseImageUrl}/${restaurant.pictureId}',
              fit: BoxFit.cover,
              width: double.infinity, // Ensure the image takes full width
              height: 250, // Set a fixed height for the image
            ),
          ),
        ),
        // Kotak di atas gambar
        Positioned(
          bottom: 10, // Posisi atas dari kotak
          left: 12, // Posisi kiri dari kotak
          right: 12, // Posisi kanan dari kotak
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.pin_drop,
                      color: Colors.grey,
                      size: 12.0,
                    ),
                    Text(restaurant.city),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

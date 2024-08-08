import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/components/list_item.dart';
import 'package:resto_app/model/restaurant.dart';
import 'package:resto_app/provider/bottom_navigation_provider.dart';
import 'package:resto_app/provider/restaurant_favorite_provider.dart';
import 'package:resto_app/provider/restaurant_provider.dart';
import 'package:resto_app/service/api_service.dart';
import 'package:resto_app/utils/Colors.dart';
import 'package:flutter/services.dart';
import 'package:resto_app/utils/constant.dart';
import 'package:resto_app/utils/enum.dart';
import 'package:resto_app/utils/notification_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject('/detail');
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.bg, // Background color
      statusBarIconBrightness: Brightness.light, // Icon color
    ));

    Widget buildList(BuildContext context, bool isFavorite) {
      return Consumer<RestaurantProvider>(builder: (context, state, _) {
        return Consumer<DatabaseProvider>(
          builder: (context, provider, child) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              if (isFavorite) {
                if (provider.favorites.isEmpty) {
                  return const Center(
                    child: Text('Daftar masih kosong'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.favorites.length,
                  itemBuilder: (context, index) {
                    var item = provider.favorites[index];
                    return RestaurantItemWidget(
                      restaurant: item,
                    );
                  },
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.result.restaurants.length,
                  itemBuilder: (context, index) {
                    var item = state.result.restaurants[index];
                    return RestaurantItemWidget(
                      restaurant: item,
                    );
                  },
                );
              }
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
        );
      });
    }

    return ChangeNotifierProvider<BottomNavigationProvider>(
        create: (_) => BottomNavigationProvider(),
        child: Scaffold(bottomNavigationBar:
            Consumer<BottomNavigationProvider>(builder: (context, provider, _) {
          return NavigationBar(
            height: 60,
            backgroundColor: AppColors.main,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.home_outlined,
                  color: AppColors.bg,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.favorite_border_outlined,
                  color: AppColors.bg,
                ),
                label: 'Favorit',
              ),
            ],
            onDestinationSelected: (int index) {
              provider.onSelectIndex(index);
            },
            indicatorColor: AppColors.accentColor,
            selectedIndex: provider.selectedIndex,
          );
        }), body: Consumer<BottomNavigationProvider>(
          builder: (context, provider, _) {
            return [
              HomeComponent(buildList: buildList),
              FavoriteComponent(buildList: buildList),
            ][provider.selectedIndex];
          },
        )));
  }
}

class HomeComponent extends StatelessWidget {
  final Widget Function(BuildContext, bool) buildList;
  const HomeComponent({Key? key, required this.buildList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(apiService: Apiservice()),
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Your action here
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Your action here
                    Navigator.pushNamed(context, '/setting');
                  },
                ),
              ],
              backgroundColor: AppColors.main,
            ),
            backgroundColor: AppColors.main,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderText(
                    title: "Restaurant",
                    subTitle: "Recommendation restaurant for you!",
                  ),
                  Expanded(
                    child: buildList(context, false),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class FavoriteComponent extends StatelessWidget {
  final Widget Function(BuildContext, bool) buildList;
  const FavoriteComponent({Key? key, required this.buildList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(apiService: Apiservice()),
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Your action here
                    Navigator.pushNamed(context, '/search');
                  },
                ),
              ],
              backgroundColor: AppColors.main,
            ),
            backgroundColor: AppColors.main,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderText(
                    title: "Favorite",
                    subTitle: "Here's your favorite",
                  ),
                  Expanded(
                    child: buildList(context, true),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String title;
  final String subTitle;
  const HeaderText({Key? key, required this.title, required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
            // Adjusted for visibility
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            subTitle,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(
            height: 12,
          ),
          // Additional content
        ]);
  }
}

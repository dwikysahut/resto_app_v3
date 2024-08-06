// restaurant_item_widget.dart
import 'package:flutter/material.dart';
import 'package:resto_app/model/restaurant.dart';
import 'package:resto_app/utils/Colors.dart';
import 'package:resto_app/utils/constant.dart';

class RestaurantItemWidget extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItemWidget({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 8.0,
      ),
      leading: Hero(
        tag: restaurant.pictureId,
        child: Image.network(
          '${Constant.baseImageUrl}/${restaurant.pictureId}',
          width: 100,
        ),
      ),
      title: Text(restaurant.name),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 3,
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Icon(
            Icons.pin_drop,
            color: Colors.grey,
            size: 12.0,
          ),
          const SizedBox(width: 2),
          Text(
            restaurant.city,
            style: const TextStyle(fontSize: 12),
          ),
        ]),
        const SizedBox(height: 4),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(
            Icons.star,
            color: AppColors.accentColor,
            size: 11.0,
          ),
          const SizedBox(width: 2),
          Text(
            restaurant.rating.toString(),
            style: const TextStyle(fontSize: 10),
          ),
        ])
      ]),
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: restaurant.id);
      },
    );
  }
}

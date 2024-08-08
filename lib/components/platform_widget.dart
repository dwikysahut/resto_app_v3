import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformWidget extends StatelessWidget {
  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;

  const PlatformWidget({
    required this.androidBuilder,
    required this.iosBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return iosBuilder(context);
    } else {
      return androidBuilder(context);
    }
  }
}

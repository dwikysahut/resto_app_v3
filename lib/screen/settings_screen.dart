import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/components/custom_dialog.dart';
import 'package:resto_app/components/platform_widget.dart';
import 'package:resto_app/utils/Colors.dart';
import 'package:resto_app/utils/schedulling_helper.dart';

class SettingsScreen extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  const SettingsScreen({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Scheduling Restaurant'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  activeColor: AppColors.bg,
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      scheduled.scheduledNews(value);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}

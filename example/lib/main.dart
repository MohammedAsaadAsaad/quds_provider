import 'package:flutter/material.dart';
import 'package:quds_provider/quds_provider.dart';

import 'providers/cars_provider.dart';
import 'providers/counder_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_page.dart';

void main() {
  runApp(MyApp());
}

QudsAppController appController = QudsAppController(
    encryptionKey: 'YourKeyEncryption',
    encryptionIV: 'hiihhiih',
    onAppSet: () => appController.restoreStateInSharedPreferences());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QudsApp(
        controller: appController,
        providers: [counterProvider, settingsProvider, carsProvider],
        child: QudsProviderWatcher<SettingsProvider>(
          builder: (s) => MaterialApp(
              title: 'Quds Provider Example',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: s!.darkTheme.v ? Brightness.dark : Brightness.light,
              ),
              home: HomePage()),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:quds_provider/_src/src.dart';

import '../main.dart';
import '../providers/counder_provider.dart';
import '../providers/settings_provider.dart';
import 'cars_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QudsProviderWatcher<CounterProvider>(
        builder: (p) => Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () =>
                          appController.saveStateInSharedPreferences()),
                  IconButton(
                      icon: Icon(Icons.agriculture_rounded),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (c) => CarsScreen())))
                ],
              ),
              body: SafeArea(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Counter:'),
                    Text(p!.counter.v.toString()),
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => p.counter.value++),
                        IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => p.counter.value--),
                      ],
                    ),
                    CheckboxListTile(
                        title: Text('Dark Theme'),
                        value: QudsApp.providerOf<SettingsProvider>(context)!
                            .darkTheme
                            .v,
                        onChanged: (v) =>
                            QudsApp.providerOf<SettingsProvider>(context)!
                                .darkTheme
                                .v = v!)
                  ],
                ),
              )),
            ));
  }
}

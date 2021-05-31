# Quds Provider 
## Simple State Manager

This package introduces to flutter developers a simple state manager.

## Features
- States are savable and restorable.
- Saved state can be encrypted.
- Data models can be integers, strings, lists, any type!


# How to use:
## To create a provider:
```dart
class CounterProvider extends QudsProvider {
  QudsValue<int> counter = QudsValue(name: 'counter', value: 0);

  @override
  List<QudsValue> getValues() => [counter];
}


class SettingsProvider extends QudsProvider {
  QudsValue<bool> darkTheme = QudsValue(name: 'dark-theme', value: false);

  @override
  List<QudsValue> getValues() => [darkTheme];
}

//Its preferred to declare the following providers in top-level
CounterProvider counterProvider = CounterProvider();
SettingsProvider settingsProvider = SettingsProvider();
```

## Wrap your app in QudsApp:

```dart
QudsAppController appController = QudsAppController(
  encryptionKey: 'YourKeyEncryption',
  encryptionIV: 'hiihhiih',
  providers: [counterProvider, settingsProvider, carsProvider],
);

Widget build(BuildContext context){
  return QudsApp(
        controller: appController,
        child:  MaterialApp(
              title: 'Quds Provider Example',
              home: HomePage()),
        );
}
```

If you want to watch the 'darkTheme change', 
wrap the MaterialApp in QudsProviderWatcher\<SettingsProvider\>

```dart
QudsApp(
        controller: appController,
        child: QudsProviderWatcher<SettingsProvider>(
          builder: (s) => MaterialApp(
              title: 'Quds Provider Example',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: s!.darkTheme.v ? Brightness.dark : Brightness.light,
              ),
              home: HomePage()),
        ));
```

To reach some value and change it:
```dart

//Reach the value and change it
Widget build(BuildContext context) {
    return QudsProviderWatcher<CounterProvider>(
        builder: (p) => Scaffold(
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
                   
                  ],
                ),
              )),
            ));
  }

```

![](https://github.com/MohammedAsaadAsaad/quds_provider/blob/main/screenshots/video1.gif?raw=true)

To add ability to control the dark theme, using the SettingsProvider:

```dart
CheckboxListTile(
                        title: Text('Dark Theme'),
                        value: QudsApp.providerOf<SettingsProvider>(context)!
                            .darkTheme
                            .v,
                        onChanged: (v) =>
                            QudsApp.providerOf<SettingsProvider>(context)!
                                .darkTheme
                                .v = v!)
```
![](https://github.com/MohammedAsaadAsaad/quds_provider/blob/main/screenshots/video2.gif?raw=true)

____
#QudsAppController
To save the current state and restore it, use QudsAppController,
and you can encrypt the state for protection

```dart
QudsAppController appController = QudsAppController(
  encryptionKey: 'YourKeyEncryption',
  encryptionIV: 'hiihhiih',
  providers: [counterProvider, settingsProvider, carsProvider],
);

void main() async{
await appController.restoreStateInSharedPreferences();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QudsApp(
        controller: appController,
        child: HomePage())}



// To save the app state:
// appController.saveStateInSharedPreferences();

// To restore the app state:
// appController.restoreStateInSharedPreferences();
```
![](https://github.com/MohammedAsaadAsaad/quds_provider/blob/main/screenshots/video3.gif?raw=true)

## QudsListNotifier
Use QudsListNotifier to set items in savable state,

```dart
CarsProvider carsProvider = CarsProvider();

class CarsProvider extends QudsProvider {
  QudsValue<QudsListNotifier<String>> cars =
      QudsValue(name: 'cars', value: QudsListNotifier<String>());
  @override
  List<QudsValue> getValues() => [cars];
}

/// Inject the carProvider in providers
QudsApp(
        controller: appController,
        providers: [counterProvider, settingsProvider, carsProvider],
...
...
)
```

And Lists are now watchable!

```dart
class CarsViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QudsProviderWatcher<CarsProvider>(builder: (p) {
      return ListView(
        children: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    p!.cars.v.add(
                        (['Toyota', 'Mercedes', 'Volvo']..shuffle()).first);
                  })
            ],
          ),
          for (var c in p!.cars.v)
            ListTile(
              title: Text(c),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => p.cars.v.remove(c),
              ),
            )
        ],
      );
    });
  }
}
```

![](https://github.com/MohammedAsaadAsaad/quds_provider/blob/main/screenshots/video4.gif?raw=true)

To update carProvider watchers for some reason:
```dart
QudsApp.providerOf<CarsProvider>(context)!.fireWatchers();
```

And lists state can be saved!
![](https://github.com/MohammedAsaadAsaad/quds_provider/blob/main/screenshots/video5.gif?raw=true)
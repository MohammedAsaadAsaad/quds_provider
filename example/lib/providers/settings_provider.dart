import 'package:quds_provider/quds_provider.dart';

SettingsProvider settingsProvider = SettingsProvider();

class SettingsProvider extends QudsProvider {
  QudsValue<bool> darkTheme = QudsValue(name: 'dark-theme', value: false);

  @override
  List<QudsValue> getValues() => [darkTheme];
}

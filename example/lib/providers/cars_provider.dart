import 'package:quds_provider/quds_provider.dart';

CarsProvider carsProvider = CarsProvider();

class CarsProvider extends QudsProvider {
  QudsValue<QudsListNotifier<String>> cars =
      QudsValue(name: 'cars', value: QudsListNotifier<String>());
  @override
  List<QudsValue> getValues() => [cars];
}

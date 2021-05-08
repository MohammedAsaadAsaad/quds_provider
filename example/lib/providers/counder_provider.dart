import 'package:quds_provider/quds_provider.dart';

CounterProvider counterProvider = CounterProvider();

class CounterProvider extends QudsProvider {
  QudsValue<int> counter = QudsValue(name: 'counter', value: 0);

  @override
  List<QudsValue> getValues() => [counter];
}

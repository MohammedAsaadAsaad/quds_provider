part of quds_provider;

///Represents an Object or [QudsListNotifier] holder
///and change notifier.
///[T] may be an object or [QudsListNotifier]
class QudsValue<T> {
  final bool? serializable;

  QudsProvider? _provider;
  final String name;

  ValueNotifier<T>? _valueNotifier;
  QudsListNotifier? _listNotifier;
  bool _isListNotifier = false;
  bool get isListNotifier => _isListNotifier;

  final T Function(Map<String, dynamic> json)? jsonGetter;

  ///[name]: the key name of the value, must be unique.
  ///[value]: an initial value.
  ///[serializable]: set weather the value can be
  ///serialized for saving and restoring.
  QudsValue(
      {required this.name,
      required T value,
      this.serializable,
      this.jsonGetter}) {
    _isListNotifier = value is QudsListNotifier;
    if (_isListNotifier)
      _listNotifier = value as QudsListNotifier;
    else
      _valueNotifier = ValueNotifier<T>(value);
    _valueNotifier?.addListener(_onChange);
    _listNotifier?.addWatcher(_onChange);
  }

  void _onChange() {
    _provider?.fireWatchers();
  }

  T get value => _isListNotifier ? _listNotifier as T : _valueNotifier!.value;
  set value(T v) {
    if (_isListNotifier) {
      var temp = v as QudsListNotifier;
      temp._list.clear();
      temp._list.addAll(temp._list);
      temp._fireWatchers();
    } else
      _valueNotifier?.value = v;
  }

  T get v => value;
  set v(T value) => this.value = value;

  void _setFromJson(dynamic obj) {
    if (jsonGetter != null) {
      v = jsonGetter!(obj);
    } else if (T == DateTime) {
      v = DateTime.tryParse(obj) as T;
    } else if (T == Color) {
      v = Color(obj) as T;
    } else if (T.toString().startsWith('QudsListNotifier')) {
      var temp = (v as QudsListNotifier);
      temp.addAllWithCasting(obj);
    } else
      v = obj;
  }

  @override
  String toString() {
    return '$value';
  }
}

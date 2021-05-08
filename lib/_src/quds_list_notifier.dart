part of quds_provider;

class QudsListNotifier<T> extends Iterable<T> {
  final T Function(Map<String, dynamic>)? jsonCreator;
  QudsListNotifier({Iterable<T>? initialList, this.jsonCreator}) {
    if (initialList != null) _list.addAll(initialList);
  }

  List<Function> _watchers = [];
  void _fireWatchers() => _watchers.forEach((element) => element.call());
  void addWatcher(Function f) => _watchers.add(f);
  void removeWatcher(Function f) => _watchers.remove(f);

  List<T> _list = [];

  void add(T entry) {
    _list.add(entry);
    _fireWatchers();
  }

  bool remove(T entry) {
    var r = _list.remove(entry);
    if (r) _fireWatchers();
    return r;
  }

  int get length => _list.length;

  Iterable<T> get reversed => _list.reversed;

  void shuffle([Random? random]) {
    _list.shuffle(random);
  }

  T get first => _list.first;
  T get last => _list.last;

  void forEach(void f(T element)) {
    for (T element in this) f(element);
  }

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => !isEmpty;

  T get single => _list.single;

  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    if (iterable.length > 0) _fireWatchers();
  }

  void addAllWithCasting(Iterable iterable) {
    if (_list is List<QudsSerializable>) {
      if (jsonCreator != null)
        _list.addAll(iterable.map<T>((e) {
          var result = jsonCreator!(e)!;
          var ser = (result as QudsSerializable);
          return ser as T;
        }));
    } else {
      _list.addAll(iterable.cast<T>());
    }

    if (iterable.length > 0) _fireWatchers();
  }

  QudsListNotifier<R> cast<R>() =>
      QudsListNotifier<R>(initialList: _list.cast<R>());

  void clear() {
    if (_list.length > 0) {
      _list.clear();
      _fireWatchers();
    }
  }

  void fillRange(int start, int end, [T? fillValue]) {
    var oldLength = _list.length;
    _list.fillRange(start, end, fillValue);
    if (_list.length != oldLength) _fireWatchers();
  }

  int indexOf(T entry, [int start = 0]) => _list.indexOf(entry, start);

  Map<int, T> asMap() => _list.asMap();

  @override
  Iterator<T> get iterator => _list.iterator;
}

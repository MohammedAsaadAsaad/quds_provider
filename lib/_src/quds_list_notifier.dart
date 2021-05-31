part of 'src.dart';

/// Represnets a list with change notifier for addition and removing.
class QudsListNotifier<T> extends Iterable<T> {
  /// Custom [T] creator using json map
  final T Function(Map<String, dynamic>)? jsonCreator;

  /// Create an instance of [QudsListNotifier]
  QudsListNotifier({Iterable<T>? initialList, this.jsonCreator}) {
    if (initialList != null) _list.addAll(initialList);
  }

  List<Function> _watchers = [];
  void _fireWatchers() => _watchers.forEach((element) => element.call());

  /// Add a watcher that be called when the value changed
  void addWatcher(Function f) => _watchers.add(f);

  /// Remove a watcher
  void removeWatcher(Function f) => _watchers.remove(f);

  List<T> _list = [];

  /// Add an entry
  void add(T entry) {
    _list.add(entry);
    _fireWatchers();
  }

  /// Remove an entry
  /// Returns true if [value] was in the list, false otherwise.
  bool remove(T entry) {
    var r = _list.remove(entry);
    if (r) _fireWatchers();
    return r;
  }

  /// Get the length of the list
  int get length => _list.length;

  // Iterable<T> get reversed => _list.reversed;

  /// Shuffles the elements of this list randomly.
  void shuffle([Random? random]) {
    _list.shuffle(random);
  }

  /// Returns the first element.
  ///
  /// Throws a [StateError] if this is empty. Otherwise returns the first element in the iteration order, equivalent to this.elementAt(0).
  T get first => _list.first;

  /// Returns the last element.
  ///
  /// Throws a [StateError] if this is empty. Otherwise may iterate through the elements and returns the last one seen. Some iterables may have more efficient ways to find the last element (for example a list can directly access the last element, without iterating through the previous ones).
  T get last => _list.last;

  void forEach(void f(T element)) {
    for (T element in this) f(element);
  }

  /// Returns true if there are no elements in this collection.
  ///
  /// May be computed by checking if iterator.moveNext() returns false.
  bool get isEmpty => _list.isEmpty;

  /// Returns true if there is at least one element in this collection.
  ///
  /// May be computed by checking if iterator.moveNext() returns true.
  bool get isNotEmpty => _list.isNotEmpty;

  /// Checks that this iterable has only one element, and returns that element.
  ///
  /// Throws a [StateError] if this is empty or has more than one element.
  T get single => _list.single;

  /// Appends all objects of [iterable] to the end of this list.
  ///
  /// Extends the length of the list by the number of objects in [iterable]. The list must be growable.
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    if (iterable.length > 0) _fireWatchers();
  }

  /// Appends all objects of [iterable] to the end of this list with casting to [T]
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

  /// Remove all entries from this list
  void clear() {
    if (_list.length > 0) {
      _list.clear();
      _fireWatchers();
    }
  }

  /// Overwrites a range of elements with [fillValue].
  ///
  /// Sets the positions greater than or equal to [start] and less than [end],
  /// to [fillValue].
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  void fillRange(int start, int end, [T? fillValue]) {
    var oldLength = _list.length;
    _list.fillRange(start, end, fillValue);
    if (_list.length != oldLength) _fireWatchers();
  }

  /// The first index of [element] in this list.
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `o == element`,
  /// the index of `o` is returned.
  int indexOf(T entry, [int start = 0]) => _list.indexOf(entry, start);

  /// An unmodifiable [Map] view of this list.
  ///
  /// The map uses the indices of this list as keys and the corresponding objects
  /// as values. The `Map.keys` [Iterable] iterates the indices of this list
  /// in numerical order.
  Map<int, T> asMap() => _list.asMap();

  @override
  Iterator<T> get iterator => _list.iterator;
}

part of quds_provider;

///Represent a state manager, holds the values
///and fires the watchers for any reported change
abstract class QudsProvider {
  Map<String, QudsValue> _values = Map();
  List<Function> _watchers = [];

  QudsProvider() {
    for (var v in getValues()) {
      _values[v.name] = v;
      v._provider = this;
    }
  }

  ///Gets the desired list of [QudsValue] to be watched.
  List<QudsValue> getValues();

  bool _updateShouldNotify(covariant QudsProvider oldWidget) {
    for (var k in _values.keys)
      if (this._values[k] != oldWidget._values[k]) return true;
    return false;
  }

  ///Add custom watcher to be fired in any reported change
  void addWatcher(Function watcher) => _watchers.add(watcher);

  ///Remove an inserted watcher, to stop firing it in any reported change.
  void removeWatcher(Function watcher) => _watchers.remove(watcher);

  ///Fire the watchers
  void fireWatchers() => _watchers.forEach((element) {
        element.call();
      });

  ///Get the state of this provider as map to be serialized
  Map toSerializableMap() {
    var values = Map<String, dynamic>();

    for (var v in _values.keys) {
      var qudsValue = _values[v]!;

      if (qudsValue.serializable != false) {
        var value;
        if (qudsValue.isListNotifier) {
          var lst = (qudsValue._listNotifier as QudsListNotifier)._list;
          value = lst.map((e) {
            var isSerializable = e is QudsSerializable;
            var json = isSerializable ? e.toJson() : e;
            return json;
          }).toList();
        } else {
          value = qudsValue._valueNotifier!.value is QudsSerializable
              ? qudsValue._valueNotifier!.value.toJson()
              : qudsValue._valueNotifier!.value;
        }
        values[v] = value;
      }
    }
    var result = {
      'provider_type': this.runtimeType.toString(),
      'values': values
    };
    return result;
  }

  ///Restore the saved state
  void fromMap(Map map) {
    var _ = map['values'];
    for (var v in _.keys) _values[v]!._setFromJson(_[v]);
    fireWatchers();
  }
}

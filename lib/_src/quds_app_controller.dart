part of quds_provider;

class QudsAppController {
  QudsApp? _app;
  bool _appAlreadySet = false;
  final Function? onAppSet;
  final String? encryptionKey;
  final String? encryptionIV;

  QudsAppController({this.onAppSet, this.encryptionKey, this.encryptionIV});

  QudsApp? get app => _app;
  set app(QudsApp? v) {
    _app = v;
    if (!_appAlreadySet && _app != null) {
      onAppSet?.call();
      _appAlreadySet = true;
    }
  }

  String? getAppStateAsJson() {
    if (app == null) return null;

    var map = {
      'providers': [for (var p in app!.providers) p.toMap()]
    };

    return json.encode(map, toEncodable: _encode);
  }

  void setAppStateFromJson(String json) {
    var map = jsonDecode(
      json,
    );
    if (app != null)
      for (var p in app!.providers) {
        for (var pp in map['providers']) {
          if (p.runtimeType.toString() == pp['provider_type']) p.fromMap(pp);
        }
      }
  }

  dynamic _encode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    } else if (item is Color)
      return item.value;
    else if (item is QudsSerializable)
      return item.toJson();
    else
      return item;
  }

  Future<bool> saveStateInSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String result = '';
      if (encryptionKey != null && encryptionIV != null) {
        final _salsaKEY = encrypt.Key.fromUtf8(encryptionKey!);
        final _salsaIV = encrypt.IV.fromUtf8(encryptionIV!);

        /// Encrypter to protected saved states of the game and
        /// make hacking a lil bit harder.
        final _encrypter = encrypt.Encrypter(encrypt.Salsa20(_salsaKEY));

        final plainText = this.getAppStateAsJson() ?? '';
        result = _encrypter.encrypt(plainText, iv: _salsaIV).base64;
      } else
        result = this.getAppStateAsJson() ?? '';

      return await prefs.setString('state', result);
    } catch (e) {
      return false;
    }
  }

  Future<bool> restoreStateInSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String result = prefs.getString('state') ?? '';
      if (encryptionKey != null && encryptionIV != null) {
        final _salsaKEY = encrypt.Key.fromUtf8(encryptionKey!);
        final _salsaIV = encrypt.IV.fromUtf8(encryptionIV!);

        /// Encrypter to protected saved states of the app and
        /// make hacking a lil bit harder.
        final _encrypter = encrypt.Encrypter(encrypt.Salsa20(_salsaKEY));

        final encrypted = encrypt.Encrypted.fromBase64(result);
        result = _encrypter.decrypt(encrypted, iv: _salsaIV);
      }

      if (result.isNotEmpty) this.setAppStateFromJson(result);

      return true;
    } catch (e) {
      return false;
    }
  }
}

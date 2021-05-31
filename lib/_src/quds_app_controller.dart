part of quds_provider;

/// A controller to manager the main [QudsApp] of the application
class QudsAppController {
  // The Quds app to manage it state.
  QudsApp? _app;

  // Indecates weather the app is set or not, for initializing.
  bool _appAlreadySet = false;

  final Function? onAppSet;
  final String? encryptionKey;
  final String? encryptionIV;
  final List<QudsProvider> providers;

  /// [onAppSet]: Called when the app is initialized.
  /// [encryptionKey], [encryptionIV] to encrypt the state of the app before saving it
  /// in SharedPreferences
  QudsAppController(
      {this.onAppSet,
      required this.providers,
      this.encryptionKey,
      this.encryptionIV});

  /// Get the [QudsApp] set to this controller.
  QudsApp? get app => _app;

  /// Set a [QudsApp] to be managed using this controller.
  set app(QudsApp? v) {
    _app = v;
    if (!_appAlreadySet && _app != null) {
      onAppSet?.call();
      _appAlreadySet = true;
    }
  }

  /// Serialize the state of the app to be saved later.
  String? getAppStateAsJson() {
    if (app == null) return null;

    var map = {
      'providers': [for (var p in providers) p.toSerializableMap()]
    };

    return json.encode(map, toEncodable: _encode);
  }

  /// Set the saved state of the app, usually at the startup of the app.
  void setAppStateFromJson(String json) {
    var map = jsonDecode(
      json,
    );

    for (var p in providers) {
      for (var pp in map['providers']) {
        if (p.runtimeType.toString() == pp['provider_type']) p.fromMap(pp);
      }
    }
  }

  /// Serialize [QudsValue] value to be saved.
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

  /// Save the state of the app in shared preferences, with encryption if required.
  Future<bool> saveStateInSharedPreferences() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
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

  /// Restore the app saved state, usually called in the startup of the app.
  Future<bool> restoreStateInSharedPreferences() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String result = prefs.getString('state') ?? '';
      if (encryptionKey != null && encryptionIV != null) {
        final _salsaKEY = encrypt.Key.fromUtf8(encryptionKey!);
        final _salsaIV = encrypt.IV.fromUtf8(encryptionIV!);

        /// Encrypter to protect saved states of the app and
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

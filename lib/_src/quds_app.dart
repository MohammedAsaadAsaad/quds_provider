part of quds_provider;

/// Represents the main container of the app.
class QudsApp extends InheritedWidget {
  /// The main controller of the app to control the state saving and storing.
  final QudsAppController controller;
  // final List<QudsProvider> providers;
  final Widget child;

  /// [controller]: The app controller to manage the state (saving and restoring),
  /// [providers]: A list of [QudsProvider], represent the state in memory storage
  /// boxes of the app.
  /// [child] the main child of the app.
  QudsApp(
      {Key? key,
      required this.controller,
      // required this.providers,
      required this.child})
      : super(key: key, child: child) {
    this.controller.app = this;
  }

  /// Return the instance of the required [QudsProvider], the instance
  /// must be included in the [providers] list
  static T? providerOf<T extends QudsProvider>(BuildContext context) {
    var app = context.dependOnInheritedWidgetOfExactType<QudsApp>();
    assert(app != null, 'There is no QudsApp initialized');
    for (var p in app!.controller.providers) {
      if (p is T) {
        return p;
      }
    }

    return null;
  }

  @override
  bool updateShouldNotify(covariant QudsApp oldApp) {
    for (var p in controller.providers) {
      QudsProvider? op;
      for (var o in oldApp.controller.providers)
        if (p.runtimeType == op.runtimeType) {
          op = o;
          break;
        }
      if (op == null || p._updateShouldNotify(op)) return true;
    }
    return false;
  }
}

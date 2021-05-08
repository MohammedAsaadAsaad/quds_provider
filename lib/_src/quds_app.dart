part of quds_provider;

///Represents the main container of the app.
class QudsApp extends InheritedWidget {
  final QudsAppController? controller;
  final List<QudsProvider> providers;
  final Widget child;

  ///[controller]: The app controller to manage the state (saving and restoring),
  ///[providers]: A list of [QudsProvider], represent the state in memory storage
  ///boxes of the app.
  ///[child] the main child of the app.
  QudsApp(
      {Key? key, this.controller, required this.providers, required this.child})
      : super(key: key, child: child) {
    if (this.controller != null) this.controller!.app = this;
  }

  ///Return the instance of the required [QudsProvider], the instance
  ///must be included in the [providers] list
  static T? providerOf<T extends QudsProvider>(BuildContext context) {
    var app = context.dependOnInheritedWidgetOfExactType<QudsApp>();
    assert(app != null, 'There is no QudsApp initialized');
    for (var p in app!.providers) {
      if (p is T) {
        return p;
      }
    }

    return null;
  }

  @override
  bool updateShouldNotify(covariant QudsApp oldApp) {
    for (var p in providers) {
      QudsProvider? op;
      for (var o in oldApp.providers)
        if (p.runtimeType == op.runtimeType) {
          op = o;
          break;
        }
      if (op == null || p._updateShouldNotify(op)) return true;
    }
    return false;
  }
}

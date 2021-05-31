part of 'src.dart';

///Represents a watcher widget of a [QudsProvider], its state reset automatically
///after any notifiable value of the desired provider,
///[P] is a generic type of [QudsProvider]
class QudsProviderWatcher<P extends QudsProvider> extends StatefulWidget {
  /// The child builder with the provider passed.
  final Widget Function(P? provider) builder;

  /// Weather this widget be rebuild when some change of the provider occured.
  final bool listen;

  ///[builder]: the builder function of the body of the watcher,
  ///[listen]: if set to true, this widget will be rebuild if any change reported
  ///at the related provider. otherwise, it will be built for once.
  const QudsProviderWatcher(
      {Key? key, required this.builder, this.listen = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State<P>();
}

class _State<P extends QudsProvider> extends State<QudsProviderWatcher<P>> {
  P? _provider;

  @override
  void initState() {
    super.initState();
  }

  bool _initialized = false;
  void _initialize(BuildContext context) {
    if (_initialized) return;
    _provider = QudsApp.providerOf<P>(context);
    if (widget.listen) _provider?.addWatcher(_refreshState);
    _initialized = true;
  }

  void _refreshState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.listen) _provider?.removeWatcher(_refreshState);
  }

  @override
  Widget build(BuildContext context) {
    _initialize(context);
    return widget.builder(QudsApp.providerOf<P>(context));
  }
}

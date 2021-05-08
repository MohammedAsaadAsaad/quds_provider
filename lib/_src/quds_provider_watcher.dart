part of quds_provider;

class QudsProviderWatcher<P extends QudsProvider> extends StatefulWidget {
  final Widget Function(P? provider) builder;
  final bool listen;

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

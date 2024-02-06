import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatus {
  static late StreamSubscription<ConnectivityResult> _subscription;
  late StreamController<ConnectivityResult> _networkStatusController;

  StreamSubscription<ConnectivityResult> get subscription => _subscription;
  StreamController<ConnectivityResult> get networkStatusController =>
      _networkStatusController;

  NetworkStatus() {
    _networkStatusController = StreamController<ConnectivityResult>();

    _invokeNetworkStatusListen();
  }

  void _invokeNetworkStatusListen() async {
    _networkStatusController.sink.add(await Connectivity().checkConnectivity());

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _networkStatusController.sink.add(result);
    });
  }

  void disposeStreams() {
    _subscription.cancel();
    _networkStatusController.close();
  }
}

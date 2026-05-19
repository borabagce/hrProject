import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@riverpod
Stream<bool> connectivityStatus(ConnectivityStatusRef ref) async* {
  final Connectivity connectivity = Connectivity();
  yield await _resolve(await connectivity.checkConnectivity());
  await for (final List<ConnectivityResult> result
      in connectivity.onConnectivityChanged) {
    yield await _resolve(result);
  }
}

Future<bool> _resolve(List<ConnectivityResult> results) async {
  return results.any((ConnectivityResult r) => r != ConnectivityResult.none);
}

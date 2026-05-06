import 'package:flutter_riverpod/legacy.dart';

enum SplashStatus {
  initial,
  checkingConnection,
  syncingOnline,
  loadingOffline,
  ready,
}

class SplashController extends StateNotifier<SplashStatus> {
  SplashController() : super(SplashStatus.initial);

  Future<void> initialize() async {
    state = SplashStatus.checkingConnection;
    await Future.delayed(const Duration(milliseconds: 800));

    final isOnline = await _hasConnection();

    if (isOnline) {
      state = SplashStatus.syncingOnline;
      await Future.delayed(const Duration(seconds: 2));
    } else {
      state = SplashStatus.loadingOffline;
      await Future.delayed(const Duration(seconds: 2));
    }

    state = SplashStatus.ready;
  }

  Future<bool> _hasConnection() async {
    // TODO: Replace with real connectivity and Dio sync logic.
    return true;
  }
}

final splashControllerProvider =
    StateNotifierProvider<SplashController, SplashStatus>(
      (ref) => SplashController(),
    );

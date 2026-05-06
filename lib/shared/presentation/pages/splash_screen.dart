import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test_dictionary/app/router/app_router.dart';
import 'package:machine_test_dictionary/app/router/navigation_helper.dart';
import 'package:machine_test_dictionary/shared/presentation/providers/splash_controller.dart';
import 'package:machine_test_dictionary/shared/presentation/templates/splash_template.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
        );

    _controller.forward();

    Future.microtask(
      () => ref.read(splashControllerProvider.notifier).initialize(),
    );

    ref.listenManual<SplashStatus>(splashControllerProvider, (previous, next) {
      if (next == SplashStatus.ready && mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          context.goTo(AppRoute.home);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashStatus = ref.watch(splashControllerProvider);

    return Scaffold(
      body: SplashTemplate(
        logoScale: _logoScale,
        fadeAnimation: _fadeAnimation,
        slideAnimation: _slideAnimation,
        statusText: _statusText(splashStatus),
      ),
    );
  }

  String _statusText(SplashStatus status) {
    switch (status) {
      case SplashStatus.checkingConnection:
        return 'Checking connectivity...';
      case SplashStatus.syncingOnline:
        return 'Syncing dictionary...';
      case SplashStatus.loadingOffline:
        return 'Loading offline library...';
      case SplashStatus.ready:
        return 'Launching your dictionary...';
      case SplashStatus.initial:
        return 'Preparing...';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../components/navigation_bar/rb_navigation_bar.dart';
import '../../provider/homepage_provider.dart';
import '../../provider/settings_provider.dart';
import '../../utils/platform.dart';
import 'views/radio_view.dart';
import 'views/settings_view.dart';

/// Home screen page.
class HomeScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WindowListener {
  final _settings = ProviderContainer();
  @override
  void initState() {
    super.initState();
    if (isDesktop) {
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
    if (isDesktop) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  Future<void> onWindowResize() async {
    await _settings
        .read(settingsProvider.notifier)
        .setWindowSize(await windowManager.getSize());
  }

  @override
  Future<void> onWindowMove() async {
    await _settings
        .read(settingsProvider.notifier)
        .setWindowPosition(await windowManager.getPosition());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: IndexedStack(
          index: ref.watch(homepageIndexProvider),
          children: [
            const RadioView(),
            SettingsView(),
          ],
        ),
        bottomNavigationBar: Consumer(
          builder: (context, ref, _) => const RBNavigationBar(),
        ),
      );
}

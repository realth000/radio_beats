import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/navigation_bar/rb_navigation_bar.dart';
import '../../provider/homepage_provider.dart';
import 'views/radio_view.dart';
import 'views/settings_view.dart';

/// Home screen page.
class HomeScreen extends ConsumerWidget {
  /// Constructor.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
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

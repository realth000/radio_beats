import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/components/navigation_bar/rb_navigation_bar.dart';
import 'package:radio_beats/providers/homepage_provider.dart';
import 'package:radio_beats/screens/home/views/favorite_view.dart';
import 'package:radio_beats/screens/home/views/radio_view.dart';
import 'package:radio_beats/screens/home/views/settings_view.dart';

/// Home screen page.
class HomeScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: IndexedStack(
          index: ref.watch(homepageIndexProvider),
          children: const [
            RadioView(),
            FavoriteView(),
            SettingsView(),
          ],
        ),
        bottomNavigationBar: Consumer(
          builder: (context, ref, _) => const RBNavigationBar(),
        ),
      );
}

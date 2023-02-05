import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/navigation_bar/rb_navigation_bar.dart';
import 'views/radio_view.dart';
import 'views/settings_view.dart';

/// Home screen page.
class HomeScreen extends ConsumerWidget {
  /// Constructor.
  HomeScreen({super.key});

  final nb = RBNavigationBar();

  final bodyViews = <Widget>[
    RadioView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(),
        body: Consumer(
          builder: (context, ref, _) => bodyViews[ref.watch(nb.index)],
        ),
        bottomNavigationBar: nb,
      );
}

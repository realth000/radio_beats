import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/providers/homepage_provider.dart';

/// RadioBeats navigation bar.
/// May be difference when on desktop and mobile, now is the same.
class RBNavigationBar extends ConsumerWidget {
  /// Constructor.
  const RBNavigationBar({super.key});

  /// Navigation bar destinations.
  /// May be difference when on desktop and mobile, now is the same.
  static const _dest = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.radio_outlined),
      label: 'Radio',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_outline),
      label: 'Favorite',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) => NavigationBar(
        destinations: _dest,
        selectedIndex: ref.watch(homepageIndexProvider),
        onDestinationSelected: (i) {
          ref.read(homepageIndexProvider.notifier).state = i;
        },
      );
}

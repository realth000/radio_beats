import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// RadioBeats navigation bar.
/// May be difference when on desktop and mobile, now is the same.
class RBNavigationBar extends ConsumerWidget {
  /// Constructor.
  RBNavigationBar({super.key});

  /// Navigation bar destinations.
  /// May be difference when on desktop and mobile, now is the same.
  final dest = <NavigationDestination>[
    const NavigationDestination(icon: Icon(Icons.radio), label: 'Radio'),
    const NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  final index = StateProvider((ref) => 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('AAAA rebuild all!!');
    return Consumer(
      builder: (context, ref, _) => NavigationBar(
        destinations: dest,
        selectedIndex: ref.watch(index),
        onDestinationSelected: (i) {
          print('AAAA update index $i');
          ref.read(index.notifier).state = i;
        },
      ),
    );
  }
}

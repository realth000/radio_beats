import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/homepage_provider.dart';

/// RadioBeats navigation bar.
/// May be difference when on desktop and mobile, now is the same.
class RBNavigationBar extends ConsumerWidget {
  /// Constructor.
  const RBNavigationBar({super.key});

  /// Navigation bar destinations.
  /// May be difference when on desktop and mobile, now is the same.
  static const _dest = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) => Consumer(
        builder: (context, ref, _) => BottomNavigationBar(
          items: _dest,
          currentIndex: ref.watch(homepageIndexProvider),
          onTap: (i) {
            ref.read(homepageIndexProvider.notifier).state = i;
          },
        ),
      );
}

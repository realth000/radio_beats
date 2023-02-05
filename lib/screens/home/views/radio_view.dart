import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/player_service.dart';

class RadioView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerService = StateProvider(
      (ref) => PlayerServiceNotifier(),
    );
    return Column(
      children: [
        Center(
          child: Text(
            'Radio View',
          ),
        ),
        ElevatedButton(
          onPressed: () async => ref
              .read(playerService.notifier)
              .state
              .play(url: 'http://stream.simulatorradio.com:8002/stream.mp3'),
          child: Text(
            'Play',
          ),
        ),
      ],
    );
  }
}

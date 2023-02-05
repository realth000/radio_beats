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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Card(
            child: ListView(),
          ),
        ),
        Card(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async =>
                        ref.read(playerService.notifier).state.play(
                              'http://stream.simulatorradio.com:8002/stream.mp3',
                            ),
                    child: const Icon(Icons.play_arrow),
                  ),
                  const SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async =>
                        ref.read(playerService.notifier).state.stop(),
                    child: const Icon(Icons.stop),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

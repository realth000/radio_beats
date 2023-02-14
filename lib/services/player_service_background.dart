import 'package:audio_service/audio_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'player_service.dart';

/// Audio control and background service on Android.
class RBAudioHandler extends BaseAudioHandler with QueueHandler {
  /// Constructor
  RBAudioHandler();

  final playerServiceContainer = ProviderContainer();

  @override
  Future<void> play() async {
    print('AAAA handler play!');
    final r = playerServiceContainer
        .read(playerServiceProvider.notifier)
        .state
        .currentRadio;
    if (r == null) {
      print('AAAA handler play NULL!');
      return;
    }
    await playerServiceContainer
        .read(playerServiceProvider.notifier)
        .state
        .play(r);
  }

  @override
  Future<void> stop() async {
    print('AAAA handler stop!');
    await playerServiceContainer
        .read(playerServiceProvider.notifier)
        .state
        .stop();
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);
  }
}

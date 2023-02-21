import 'package:audio_service/audio_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'player_provider.dart';

/// Audio control and background service on Android.
class RBAudioHandler extends BaseAudioHandler with QueueHandler {
  /// Constructor
  RBAudioHandler();

  final playerContainer = ProviderContainer();

  @override
  Future<void> play() async {
    print('AAAA handler play!');
    final r = playerContainer.read(playerProvider.notifier).state.currentRadio;
    if (r == null) {
      print('AAAA handler play NULL!');
      return;
    }
    await playerContainer.read(playerProvider.notifier).state.play(r);
  }

  @override
  Future<void> stop() async {
    print('AAAA handler stop!');
    await playerContainer.read(playerProvider.notifier).state.stop();
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);
  }
}

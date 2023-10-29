import 'package:audio_service/audio_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/providers/player_provider.dart';

/// Audio control and background service on Android.
class RBAudioHandler extends BaseAudioHandler with QueueHandler {
  /// Constructor
  RBAudioHandler();

  final _playerContainer = ProviderContainer();

  @override
  Future<void> play() async {
    final r = _playerContainer.read(playerProvider).currentRadio;
    if (r == null) {
      return;
    }
    await _playerContainer.read(playerProvider.notifier).play(r);
  }

  @override
  Future<void> stop() async {
    await _playerContainer.read(playerProvider.notifier).stop();
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);
  }
}

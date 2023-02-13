import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radio_beats/services/player_service_background.dart';

import '../utils/platform.dart';

late final AudioHandler _audioHandler;

/// Init audio background service on Android.
Future<void> initAudioBackgroundService() async {
  _audioHandler = await AudioService.init(
    builder: RBAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
}

class PlayerService {
  final _player = AudioPlayer();

  Future<void> play(String url) async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }
    await _player.play(UrlSource(url));
    if (isAndroid) {
      final item = MediaItem(
        id: 'https://example.com/audio.mp3',
        album: 'Album name',
        title: 'Track title',
        artist: 'Artist name',
        duration: const Duration(milliseconds: 123456),
        artUri: Uri.parse('https://example.com/album.jpg'),
      );
      await _audioHandler.play();
    }
  }

  Future<void> stop() async {
    await _player.stop();
    if (isAndroid) {
      await _audioHandler.stop();
    }
  }
}

class _PlayerServiceNotifier extends StateNotifier<PlayerService> {
  /// Constructor.
  _PlayerServiceNotifier() : super(PlayerService());
}

final playerServiceProvider =
    StateNotifierProvider<_PlayerServiceNotifier, PlayerService>(
  (ref) => _PlayerServiceNotifier(),
);

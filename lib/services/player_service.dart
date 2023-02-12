import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radio_beats/services/player_service_background.dart';

import '../utils/platform.dart';

class PlayerService {
  final _player = AudioPlayer();

  Future<void> play(String url) async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }
    await _player.play(UrlSource(url));
  }

  Future<void> stop() async {
    await _player.stop();
  }
}

final _player = PlayerService();

late final AudioHandler _audioHandler;

/// Init audio background service on Android.
Future<void> initAudioBackgroundService() async {
  _audioHandler = await AudioService.init(
    builder: RBAudioHandler.new,
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
}

class PlayerServiceNotifier extends StateNotifier<PlayerService> {
  /// Constructor.
  PlayerServiceNotifier() : super(_player);

  Future<void> play(String url) async {
    await _player.play(url);
    if (isAndroid) {
      var item = MediaItem(
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

// final playerServiceProvider =
//     StateNotifierProvider<PlayerServiceNotifier, List<PlayerService>>(
//   (ref) => PlayerServiceNotifier(),
// );

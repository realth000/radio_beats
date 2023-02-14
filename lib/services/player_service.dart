import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radio_beats/services/player_service_background.dart';

import '../models/radio_model.dart';
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
  RadioModel? currentRadio;

  final _player = AudioPlayer();

  Future<void> play(RadioModel radioModel) async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }
    await _player.play(UrlSource(radioModel.url));
    if (isAndroid) {
      await _audioHandler.playMediaItem(
        MediaItem(
          id: radioModel.url,
          //album: 'Album name',
          title: radioModel.name,
          //artist: radioModel.name,
          //duration: const Duration(milliseconds: 123456),
          //artUri: Uri.parse('https://example.com/album.jpg'),
        ),
      );
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

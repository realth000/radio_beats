import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/radio_model.dart';
import '../utils/platform.dart';
import 'player_service_background.dart';

late final RBAudioHandler _audioHandler;

/// Init audio background service on Android.
Future<void> initAudioBackgroundService() async {
  print('AAAA initAudioBackgroundService');
  _audioHandler = await AudioService.init(
    builder: RBAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
}

class PlayerService {
  /// Constructor.
  PlayerService() {
    if (isAndroid) {
      _player.onPlayerStateChanged.listen((state) async {
        print('AAAA register state change！');
        _audioHandler.playbackState.add(await _transformEvent(state));
      });
    }
  }

  RadioModel? currentRadio;

  final _player = AudioPlayer();

  Future<PlaybackState> _transformEvent(PlayerState event) async =>
      PlaybackState(
        controls: [
          MediaControl.play,
          MediaControl.stop,
        ],
        systemActions: const {
          MediaAction.play,
          MediaAction.stop,
        },
        androidCompactActionIndices: const [0, 2],
        processingState: const {
          PlayerState.stopped: AudioProcessingState.idle,
          PlayerState.playing: AudioProcessingState.ready,
          PlayerState.paused: AudioProcessingState.ready,
          PlayerState.completed: AudioProcessingState.completed,
        }[_player.state]!,
        playing: _player.state == PlayerState.playing,
        updatePosition: await _player.getCurrentPosition() ?? Duration.zero,
        bufferedPosition: await _player.getDuration() ?? Duration.zero,
        queueIndex: 0,
      );

  Future<void> play(RadioModel radioModel) async {
    print('AAAA player service start!');
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }
    currentRadio = radioModel;
    await _player.play(UrlSource(radioModel.url));
    if (isAndroid) {
      print('AAAA set playMediaItem');
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
    print('AAAA player service stop!');
    await _player.stop();
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

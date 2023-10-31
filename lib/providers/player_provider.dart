import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/models/radio_model.dart';
import 'package:radio_beats/providers/player_background_provider.dart';
import 'package:radio_beats/providers/settings_provider.dart';
import 'package:radio_beats/utils/platform.dart';

late final RBAudioHandler _audioHandler;

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

/// Init player.
Future<void> initPlayWhenStart() async {
  final pc = ProviderContainer();
  final model = pc.read(settingsProvider).defaultModel;
  if (model == null) {
    return;
  }
  if (pc.read(settingsProvider).playWhenStart) {
    await pc.read(playerProvider.notifier).play(null);
  }
}

/// Music player class.
class Player {
  /// Constructor.
  Player() {
    if (isAndroid) {
      _player.onPlayerStateChanged.listen((state) async {
        _audioHandler.playbackState.add(await _transformEvent(state));
      });
    }
  }

  /// Current radio model.
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
}

class _PlayerNotifier extends StateNotifier<Player> {
  /// Constructor.
  _PlayerNotifier() : super(Player());

  Future<void> setVolume(double volume) async {
    await state._player.setVolume(volume);
  }

  Future<void> play(RadioModel? radioModel) async {
    if (radioModel == null && state.currentRadio == null) {
      return;
    }
    if (state._player.state == PlayerState.playing) {
      await state._player.stop();
    }
    if (radioModel != null) {
      state.currentRadio = radioModel;
    }
    final source = UrlSource(radioModel!.url);
    await source.setOnPlayer(state._player);
    await state._player.resume();
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
    await state._player.stop();
  }
}

/// Global provider os [Player].
final playerProvider = StateNotifierProvider<_PlayerNotifier, Player>(
  (ref) => _PlayerNotifier(),
);

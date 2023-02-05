import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PlayerServiceNotifier extends StateNotifier<PlayerService> {
  /// Constructor.
  PlayerServiceNotifier() : super(_player);

  Future<void> play(String url) async {
    await _player.play(url);
  }

  Future<void> stop() async {
    await _player.stop();
  }
}

// final playerServiceProvider =
//     StateNotifierProvider<PlayerServiceNotifier, List<PlayerService>>(
//   (ref) => PlayerServiceNotifier(),
// );

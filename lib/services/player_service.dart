import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerService {
  final _player = AudioPlayer();

  Future<void> play({url = ''}) async {
    if (_player.state == PlayerState.playing) {
      print('AAAA stop play $url');
      await _player.stop();
      print('AAAA finish stop play $url');
    }
    print('AAAA start play $url');
    await _player.play(UrlSource(url));
    print('AAAA finish play $url');
  }
}

final _player = PlayerService();

class PlayerServiceNotifier extends StateNotifier<PlayerService> {
  /// Constructor.
  PlayerServiceNotifier() : super(_player);

  Future<void> play({url = ''}) async {
    await _player.play(url: url);
  }
}

// final playerServiceProvider =
//     StateNotifierProvider<PlayerServiceNotifier, List<PlayerService>>(
//   (ref) => PlayerServiceNotifier(),
// );

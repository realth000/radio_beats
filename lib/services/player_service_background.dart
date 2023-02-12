import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'player_service.dart';

/// Audio control and background service on Android.
class RBAudioHandler extends BaseAudioHandler with QueueHandler {
  /// Constructor
  RBAudioHandler();

  final playerService = StateProvider((ref) => PlayerServiceNotifier());
  final s = StateNotifierProvider((ref) => PlayerServiceNotifier());

  @override
  Future<void> play() async {}

  @override
  Future<void> stop() async {
    //
  }
}

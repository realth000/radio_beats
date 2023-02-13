import 'package:audio_service/audio_service.dart';

/// Audio control and background service on Android.
class RBAudioHandler extends BaseAudioHandler with QueueHandler {
  /// Constructor
  RBAudioHandler();

  @override
  Future<void> play() async {}

  @override
  Future<void> stop() async {
    //
  }
}

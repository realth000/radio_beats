import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/settings_model.dart';

/// Global settings provider.
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);

/// Notifier for settings.
class SettingsNotifier extends StateNotifier<Settings> {
  /// Constructor.
  SettingsNotifier() : super(Settings());

  final _box = Hive.box('settings');

  /// Save value of key to storage.
  Future<bool> save(String key, dynamic value) async {
    if (_box.get(key).runtimeType != value.runtimeType) {
      print(
          'AAAA $key value type is ${_box.get(key).runtimeType}, but value to save is ${value.runtimeType}');
      return false;
    }
    await _box.put(key, value);
    return true;
  }

  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    await _box.put('volume', volume);
  }
}

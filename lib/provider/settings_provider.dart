import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings_model.dart';

late final _SettingsService _storage;

/// Global settings provider.
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);

/// Init settings.
Future<void> initSettings() async {
  _storage = await _SettingsService().init();
}

class _SettingsService {
  late final SharedPreferences _sp;
  Future<_SettingsService> init() async {
    _sp = await SharedPreferences.getInstance();
    return this;
  }

  dynamic get(String key) => _sp.get(key);

  /// Get int type value of specified key.
  int? getInt(String key) => _sp.getInt(key);

  /// Sae int type value of specified key.
  Future<bool> saveInt(String key, int value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setInt(key, value);
    return true;
  }

  /// Get bool type value of specified key.
  bool? getBool(String key) => _sp.getBool(key);

  /// Save bool type value of specified value.
  Future<bool> saveBool(String key, bool value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setBool(key, value);
    return true;
  }

  /// Get double type value of specified key.
  double? getDouble(String key) => _sp.getDouble(key);

  /// Save double type value of specified key.
  Future<bool> saveDouble(String key, double value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setDouble(key, value);
    return true;
  }

  /// Get string type value of specified key.
  String? getString(String key) => _sp.getString(key);

  /// Save string type value of specified key.
  Future<bool> saveString(String key, String value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setString(key, value);
    return true;
  }

  /// Get string list type value of specified key.
  List<String>? getStringList(String key) => _sp.getStringList(key);

  /// Save string list type value of specified key.
  Future<bool> saveStringList(String key, List<String> value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setStringList(key, value);
    return true;
  }
}

/// Notifier for settings.
class SettingsNotifier extends StateNotifier<Settings> {
  /// Constructor.
  SettingsNotifier()
      : super(
          Settings(
            volume: _storage.get('volume') ?? 0.5,
          ),
        );

  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    await _storage.saveDouble('volume', volume);
  }
}

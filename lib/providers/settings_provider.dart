import 'dart:convert';
import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radio_beats/models/radio_model.dart';
import 'package:radio_beats/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

extension _RadioBeatsSettings on _SettingsService {
  /// Get default [RadioModel] to get.
  RadioModel? getRadioModel(String key) {
    final m = _storage.getString(key);
    if (m == null) {
      return null;
    }
    return RadioModel.fromJson(jsonDecode(m));
  }
}

/// Notifier for settings.
class SettingsNotifier extends StateNotifier<Settings> {
  /// Constructor.
  SettingsNotifier()
      : super(
          Settings(
            volume: _storage.getDouble('volume') ?? _defaultVolume,
            lastNotZeroVolume: _storage.getDouble('lastNotZeroVolume') ??
                _defaultLastNotZeroVolume,
            windowWidth:
                _storage.getDouble('windowWidth') ?? _defaultWindowWidth,
            windowHeight:
                _storage.getDouble('windowHeight') ?? _defaultWindowHeight,
            windowPositionDx: _storage.getDouble('windowPositionDx') ??
                _defaultWindowPositionDx,
            windowPositionDy: _storage.getDouble('windowPositionDy') ??
                _defaultWindowPositionDy,
            windowInCenter:
                _storage.getBool('windowInCenter') ?? _defaultWindowInCenter,
            defaultModel: _storage.getRadioModel('defaultModel'),
            playWhenStart:
                _storage.getBool('playWhenStart') ?? _defaultPlayWhenStart,
          ),
        );

  static const _defaultVolume = 0.5;
  static const _defaultLastNotZeroVolume = _defaultVolume;
  static const _defaultWindowPositionDx = 0.0;
  static const _defaultWindowPositionDy = 0.0;
  static const _defaultWindowWidth = 600.0;
  static const _defaultWindowHeight = 480.0;
  static const _defaultWindowInCenter = false;
  static const _defaultPlayWhenStart = false;

  /// Set volume value, not less than zero.
  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    await _storage.saveDouble('volume', volume);
  }

  /// Set last not zero value, greater than zero.
  Future<void> setLastNotZeroVolume(double volume) async {
    if (volume == 0) {
      return;
    }
    state = state.copyWith(lastNotZeroVolume: volume);
    await _storage.saveDouble('lastNotZeroVolume', volume);
  }

  /// Set window size, greater than zero.
  Future<void> setWindowSize(Size size) async {
    await _storage.saveDouble('windowWidth', size.width);
    await _storage.saveDouble('windowHeight', size.height);
    state = state.copyWith(
      windowPositionDx: size.width,
      windowPositionDy: size.height,
    );
  }

  /// Set window position.
  Future<void> setWindowPosition(Offset offset) async {
    await _storage.saveDouble('windowPositionDx', offset.dx);
    await _storage.saveDouble('windowPositionDy', offset.dy);
    state = state.copyWith(
      windowPositionDx: offset.dx,
      windowPositionDy: offset.dy,
    );
  }

  /// Set window whether in center.
  ///
  /// If true, override window position configs.
  Future<void> setWindowInCenter(bool value) async {
    await _storage.saveBool('windowInCenter', value);
    state = state.copyWith(
      windowInCenter: value,
    );
  }

  /// Set default [RadioModel] to use after start.
  Future<void> setDefaultModel(RadioModel model) async {
    await _storage.saveString('defaultModel', jsonEncode(model.toJson()));
    state = state.copyWith(
      defaultModel: model,
    );
  }

  /// Set whether auto play after app start.
  Future<void> setPlayWhenStart(bool play) async {
    await _storage.saveBool('playWhenStart', play);
    state = state.copyWith(
      playWhenStart: play,
    );
  }
}

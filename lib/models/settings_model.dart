import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';

/// Settings model for app, also used in storage.
@freezed
class Settings with _$Settings {
  /// Constructor.
  const factory Settings({
    required double volume,
    required double lastNotZeroVolume,
    required double windowWidth,
    required double windowHeight,
    required double windowPositionDx,
    required double windowPositionDy,
    required bool windowInCenter,
  }) = _Settings;
}

/// All settings and value types.
const Map<String, Type> settingsMap = <String, Type>{
  'volume': double,
  'lastNotZeroVolume': double,
  'windowWidth': double,
  'windowHeight': double,
  'windowPositionDx': double,
  'windowPositionDy': double,
  'windowInCenter': bool,
};

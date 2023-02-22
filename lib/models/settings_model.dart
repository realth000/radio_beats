import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';

/// Settings model for app, also used in storage.
@freezed
class Settings with _$Settings {
  /// Constructor.
  const factory Settings({
    required double volume,
  }) = _Settings;
}

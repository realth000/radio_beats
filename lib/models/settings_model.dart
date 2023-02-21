import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Settings {
  /// Default constructor.
  Settings();

  /// Constructor from raw value
  Settings.raw({
    required this.volume,
  });

  /// Player volume.
  double volume = 0.5;

  Map<String, dynamic> get toMap => <String, dynamic>{
        'volume': volume,
      };

  /// Copy with another
  Settings copyWith({
    double? volume,
  }) =>
      Settings.raw(
        volume: volume ?? this.volume,
      );
}

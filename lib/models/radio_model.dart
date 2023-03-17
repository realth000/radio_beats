import 'package:freezed_annotation/freezed_annotation.dart';

part 'radio_model.freezed.dart';
part 'radio_model.g.dart';

/// RadioModel contains a radio target.
///
/// Including radio name, radio url with optional radio style, radio language,
/// and radio sample rate.
@freezed
class RadioModel with _$RadioModel {
  /// Constructor
  const factory RadioModel({
    /// Radio name to display.
    required String name,

    /// Radio url to fetch music stream.
    required String url,

    /// Music style, can be null.
    String? style,

    /// Music language (code), can be null.
    String? language,

    /// Radio samplerate, can be null.
    int? sampleRate,
  }) = _RadioModel;

  /// Build from json.
  factory RadioModel.fromJson(Map<String, Object?> json) =>
      _$RadioModelFromJson(json);
}

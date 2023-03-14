/// RadioModel contains a radio target.
///
/// Including radio name, radio url with optional radio style, radio language,
/// and radio sample rate.
class RadioModel {
  /// Constructor
  RadioModel(this.name, this.url, {this.style, this.language, this.sampleRate});

  /// Radio name to display.
  String name;

  /// Radio url to fetch music stream.
  String url;

  /// Music style, can be null.
  String? style;

  /// Music language (code), can be null.
  String? language;

  /// Radio samplerate, can be null.
  int? sampleRate;
}

/// RadioModel contains a radio target.
///
/// Including radio name, radio url with optional radio style, radio language,
/// and radio sample rate.
class RadioModel {
  /// Constructor
  RadioModel(this.name, this.url, {this.style, this.language, this.sampleRate});

  String name;
  String url;
  String? style;
  String? language;
  int? sampleRate;
}

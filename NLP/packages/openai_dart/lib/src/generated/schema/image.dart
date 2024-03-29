// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: invalid_annotation_target
part of open_a_i_schema;

// ==========================================
// CLASS: Image
// ==========================================

/// Represents the url or the content of an image generated by the OpenAI API.
@freezed
class Image with _$Image {
  const Image._();

  /// Factory constructor for Image
  const factory Image({
    /// The base64-encoded JSON of the generated image, if `response_format` is `b64_json`.
    @JsonKey(name: 'b64_json', includeIfNull: false) String? b64Json,

    /// The URL of the generated image, if `response_format` is `url` (default).
    @JsonKey(includeIfNull: false) String? url,

    /// The prompt that was used to generate the image, if there was any revision to the prompt.
    @JsonKey(name: 'revised_prompt', includeIfNull: false)
    String? revisedPrompt,
  }) = _Image;

  /// Object construction from a JSON representation
  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  /// List of all property names of schema
  static const List<String> propertyNames = [
    'b64_json',
    'url',
    'revised_prompt'
  ];

  /// Perform validations on the schema property values
  String? validateSchema() {
    return null;
  }

  /// Map representation of object (not serialized)
  Map<String, dynamic> toMap() {
    return {
      'b64_json': b64Json,
      'url': url,
      'revised_prompt': revisedPrompt,
    };
  }
}

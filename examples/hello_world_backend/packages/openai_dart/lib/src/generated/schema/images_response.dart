// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: invalid_annotation_target
part of open_a_i_schema;

// ==========================================
// CLASS: ImagesResponse
// ==========================================

/// Represents a generated image returned by the images endpoint.
@freezed
class ImagesResponse with _$ImagesResponse {
  const ImagesResponse._();

  /// Factory constructor for ImagesResponse
  const factory ImagesResponse({
    /// The Unix timestamp (in seconds) when the image was created.
    required int created,

    /// The list of images generated by the model.
    required List<Image> data,
  }) = _ImagesResponse;

  /// Object construction from a JSON representation
  factory ImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$ImagesResponseFromJson(json);

  /// List of all property names of schema
  static const List<String> propertyNames = ['created', 'data'];

  /// Perform validations on the schema property values
  String? validateSchema() {
    return null;
  }

  /// Map representation of object (not serialized)
  Map<String, dynamic> toMap() {
    return {
      'created': created,
      'data': data,
    };
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/breed.dart';
import '../../domain/models/cat_image.dart';

/// Remote data source that communicates with TheCatAPI.
class CatApiDatasource {
  /// Injected at build-time via --dart-define-from-file=env.json
  static const _apiKey = String.fromEnvironment('CAT_API_KEY');

  static const _headers = {'x-api-key': _apiKey};

  final http.Client _client;
  final Duration _timeout;

  CatApiDatasource({http.Client? client, Duration timeout = const Duration(seconds: 30)})
      : _client = client ?? http.Client(),
        _timeout = timeout;

  Future<String> fetchRandomImageId() async {
    final response = await _client.get(
      Uri.https('api.thecatapi.com', '/v1/images/search', {
        'has_breeds': '1',
      }),
      headers: _headers,
    ).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to find image. Status code: ${response.statusCode}',
      );
    }

    final List<dynamic> searchData = jsonDecode(response.body);

    if (searchData.isEmpty) {
      throw Exception('No images found.');
    }

    return searchData[0]['id'] as String;
  }

  Future<CatImage> fetchImageData(String imageId) async {
    final response = await _client.get(
      Uri.https('api.thecatapi.com', '/v1/images/$imageId'),
      headers: _headers,
    ).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get image data. Status code: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;

    return _parseCatImage(json);
  }

  Future<List<Breed>> fetchAllBreeds() async {
    final response = await _client.get(
      Uri.https('api.thecatapi.com', '/v1/breeds'),
      headers: _headers,
    ).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to find breeds data. Status code: ${response.statusCode}',
      );
    }

    final List<dynamic> breedsJson = jsonDecode(response.body);

    return breedsJson.map(_parseBreed).toList();
  }

  CatImage _parseCatImage(Map<String, dynamic> json) {
    final breedsJson = json['breeds'] as List<dynamic>? ?? [];
    return CatImage(
      id: json['id'] as String,
      url: json['url'] as String,
      breeds: breedsJson
          .map((b) => _parseBreed(b as Map<String, dynamic>))
          .toList(),
    );
  }

  Breed _parseBreed(dynamic json) {
    final map = json as Map<String, dynamic>;
    return Breed(
      id: map['id']?.toString() ?? '',
      name: map['name'] as String? ?? 'Unknown',
      description: map['description'] as String? ?? '',
      weight: (map['weight'] as Map<String, dynamic>?)?['metric'] as String?,
      lifeSpan: map['life_span'] as String?,
      temperament: map['temperament'] as String?,
      referenceImageId: map['reference_image_id'] as String?,
    );
  }
}

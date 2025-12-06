import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchImageData(String imageId) async {
    try {
      final getResponse = await http.get(
        Uri.https("api.thecatapi.com", "/v1/images/$imageId"),
      );

      if (getResponse.statusCode != 200) {
        throw Exception(
          "Failed to get image data. Status code: ${getResponse.statusCode}",
        );
      }

      return jsonDecode(getResponse.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Did not manage to fetch image data. $e");
    }
  }
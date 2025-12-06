import 'dart:convert';

import 'package:catinder/utils/dialogs.dart';
import 'package:catinder/utils/fetch_image_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/cat_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _likesCounter = 0;

  late Future<Map<String, dynamic>> _imageDataFuture;

  bool _errorDialogShown = false;

  void _incrementLikesCounter() {
    _likesCounter++;
  }

  Future<String> _fetchRandomImageId() async {
    try {
      final response = await http.get(
        Uri.https("api.thecatapi.com", "/v1/images/search", {
          "has_breeds": "1",
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to find image. Status code: ${response.statusCode}",
        );
      }

      final List<dynamic> searchData = jsonDecode(response.body);

      if (searchData.isEmpty) {
        throw Exception("No images found.");
      }

      final String id = searchData[0]['id'];

      return id;
    } catch (e) {
      throw Exception("Did not manage to fetch data. $e");
    }
  }

  void _getNewImageData() {
    _imageDataFuture = _fetchRandomImageId().then((imageId) {
      return fetchImageData(imageId);
    });
  }

  void _like() {
    setState(() {
      _incrementLikesCounter();
      _getNewImageData();
    });
  }

  void _dislike() {
    setState(() {
      _getNewImageData();
    });
  }

  void _tryShowErrorDialog(BuildContext context, Object error) {
    if (_errorDialogShown) return;

    _errorDialogShown = true;

    showErrorDialog(context, error.toString()).then((_) {
      _errorDialogShown = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getNewImageData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.red),
            Text(" $_likesCounter"),
          ],
        ),
        Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              _dislike();
            } else {
              _like();
            }
          },
          child: CatCard(
            imageDataFuture: _imageDataFuture,
            onError: (err) =>
                _tryShowErrorDialog(context, err ?? 'Unknown error'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () => _like(),
              child: Icon(Icons.thumb_up),
            ),
            SizedBox(width: 50),
            FloatingActionButton(
              onPressed: () => _dislike(),
              child: Icon(Icons.thumb_down),
            ),
          ],
        ),
      ],
    );
  }
}

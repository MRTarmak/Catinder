import 'dart:convert';

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

  late Future<Map<String, dynamic>> _dataFuture;

  void _incrementLikesCounter() {
    _likesCounter++;
  }

  Future<Map<String, dynamic>> _fetchImageData() async {
    try {
      final searchResponse = await http.get(
        Uri.https("api.thecatapi.com", "/v1/images/search", {
          "has_breeds": "1",
        }),
      );

      if (searchResponse.statusCode != 200) {
        throw Exception(
          "Failed to find image. Status code: ${searchResponse.statusCode}",
        );
      }

      final List<dynamic> searchData = jsonDecode(searchResponse.body);

      if (searchData.isEmpty) {
        throw Exception("No images found.");
      }

      final String id = searchData[0]['id'];

      final getResponse = await http.get(
        Uri.https("api.thecatapi.com", "/v1/images/$id"),
      );

      if (getResponse.statusCode != 200) {
        throw Exception(
          "Failed to get image data. Status code: ${getResponse.statusCode}",
        );
      }

      return jsonDecode(getResponse.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Did not manage to fetch data. $e");
    }
  }

  void _getNewData() {
    _dataFuture = _fetchImageData();
  }

  void _like() {
    setState(() {
      _incrementLikesCounter();
      _getNewData();
    });
  }

  void _dislike() {
    setState(() {
      _getNewData();
    });
  }

  @override
  void initState() {
    super.initState();
    _getNewData();
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
          child: CatCard(dataFuture: _dataFuture),
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

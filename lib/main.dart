import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CatinderApp());
}

class CatinderApp extends StatelessWidget {
  const CatinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: IndexedStackScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _likesCounter = 0;

  late Future<Map<String, dynamic>> _dataFuture;

  void _incrementLikesCounter() {
    setState(() {
      _likesCounter++;
    });
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
            Icon(Icons.thumb_up),
            Text(" $_likesCounter"),
          ], // TODO find relevant icon
        ),
        Card(
          child: FutureBuilder(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    Image.network(snapshot.data!['url']),
                    Text(snapshot.data!['breeds'][0]['name']),
                  ],
                );
              }
              throw Exception("Unexpected state in FutureBuilder");
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: _incrementLikesCounter,
              child: Icon(Icons.thumb_up),
            ),
            FloatingActionButton(
              onPressed: () {}, // TODO implement dislike functionality
              child: Icon(Icons.thumb_down),
            ),
          ],
        ),
      ],
    );
  }
}

class IndexedStackScreen extends StatefulWidget {
  const IndexedStackScreen({super.key});

  @override
  State<IndexedStackScreen> createState() => _IndexedStackScreenState();
}

class _IndexedStackScreenState extends State<IndexedStackScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text('Breeds List Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catinder")),
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Breeds'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

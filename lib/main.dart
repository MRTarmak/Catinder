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
      title: 'Catinder',
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

class CatCard extends StatelessWidget {
  final Future<Map<String, dynamic>> _dataFuture;

  const CatCard({super.key, required Future<Map<String, dynamic>> dataFuture})
    : _dataFuture = dataFuture;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: 8.0,
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: FutureBuilder(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Error: ${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                print(snapshot.data!['url']);
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        snapshot.data!['url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Text(
                        snapshot.data!['breeds'][0]['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }
              throw Exception("Unexpected state in FutureBuilder");
            },
          ),
        ),
      ),
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

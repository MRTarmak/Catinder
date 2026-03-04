import 'package:flutter/material.dart';

import '../state/breed_image_state.dart';
import '../state/breeds_list_state.dart';
import '../state/home_state.dart';
import 'breeds_list_page.dart';
import 'home_page.dart';

class IndexedStackScreen extends StatefulWidget {
  final HomeState homeState;
  final BreedsListState breedsListState;
  final BreedImageState breedImageState;

  const IndexedStackScreen({
    super.key,
    required this.homeState,
    required this.breedsListState,
    required this.breedImageState,
  });

  @override
  State<IndexedStackScreen> createState() => _IndexedStackScreenState();
}

class _IndexedStackScreenState extends State<IndexedStackScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(state: widget.homeState),
      BreedsListPage(
        state: widget.breedsListState,
        imageState: widget.breedImageState,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Catinder',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
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

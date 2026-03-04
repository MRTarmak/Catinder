import 'package:flutter/material.dart';

import 'data/datasources/cat_api_datasource.dart';
import 'data/repositories/cat_repository_impl.dart';
import 'presentation/screens/indexed_stack_screen.dart';
import 'presentation/state/breed_image_state.dart';
import 'presentation/state/breeds_list_state.dart';
import 'presentation/state/home_state.dart';

void main() {
  final datasource = CatApiDatasource();
  final repository = CatRepositoryImpl(datasource: datasource);

  final homeState = HomeState(repository: repository);
  final breedsListState = BreedsListState(repository: repository);
  final breedImageState = BreedImageState(repository: repository);

  runApp(CatinderApp(
    homeState: homeState,
    breedsListState: breedsListState,
    breedImageState: breedImageState,
  ));
}

class CatinderApp extends StatelessWidget {
  final HomeState homeState;
  final BreedsListState breedsListState;
  final BreedImageState breedImageState;

  const CatinderApp({
    super.key,
    required this.homeState,
    required this.breedsListState,
    required this.breedImageState,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: IndexedStackScreen(
        homeState: homeState,
        breedsListState: breedsListState,
        breedImageState: breedImageState,
      ),
    );
  }
}

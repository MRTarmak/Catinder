import 'package:flutter/material.dart';

import 'data/datasources/cat_api_datasource.dart';
import 'data/repositories/cat_repository_impl.dart';
import 'presentation/screens/indexed_stack_screen.dart';
import 'data/datasources/onboarding_storage.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/state/breed_image_state.dart';
import 'presentation/state/breeds_list_state.dart';
import 'presentation/state/home_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final showOnboarding = !(await isOnboardingCompleted());

  final datasource = CatApiDatasource();
  final repository = CatRepositoryImpl(datasource: datasource);

  final homeState = HomeState(repository: repository);
  final breedsListState = BreedsListState(repository: repository);
  final breedImageState = BreedImageState(repository: repository);

  runApp(CatinderApp(
    homeState: homeState,
    breedsListState: breedsListState,
    breedImageState: breedImageState,
    showOnboarding: showOnboarding,
  ));
}

class CatinderApp extends StatefulWidget {
  final HomeState homeState;
  final BreedsListState breedsListState;
  final BreedImageState breedImageState;
  final bool showOnboarding;

  const CatinderApp({
    super.key,
    required this.homeState,
    required this.breedsListState,
    required this.breedImageState,
    required this.showOnboarding,
  });

  @override
  State<CatinderApp> createState() => _CatinderAppState();
}

class _CatinderAppState extends State<CatinderApp> {
  late bool _showOnboarding;

  @override
  void initState() {
    super.initState();
    _showOnboarding = widget.showOnboarding;
  }

  void _onOnboardingComplete() {
    setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _showOnboarding
          ? OnboardingScreen(onComplete: _onOnboardingComplete)
          : IndexedStackScreen(
              homeState: widget.homeState,
              breedsListState: widget.breedsListState,
              breedImageState: widget.breedImageState,
            ),
    );
  }
}

// flutter run -d chrome --web-browser-flag="--disable-web-security" --dart-define-from-file=env.json
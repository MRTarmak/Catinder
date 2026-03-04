import 'package:flutter/material.dart';

import 'data/datasources/auth_storage.dart';
import 'data/datasources/cat_api_datasource.dart';
import 'data/datasources/onboarding_storage.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/cat_repository_impl.dart';
import 'presentation/screens/indexed_stack_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/sign_up_screen.dart';
import 'presentation/state/auth_state.dart';
import 'presentation/state/breed_image_state.dart';
import 'presentation/state/breeds_list_state.dart';
import 'presentation/state/home_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final showOnboarding = !(await isOnboardingCompleted());

  final authStorage = AuthStorage();
  final authRepository = AuthRepositoryImpl(storage: authStorage);
  final isLoggedIn = await authRepository.isLoggedIn();

  final datasource = CatApiDatasource();
  final catRepository = CatRepositoryImpl(datasource: datasource);

  final authState = AuthState(repository: authRepository);
  final homeState = HomeState(repository: catRepository);
  final breedsListState = BreedsListState(repository: catRepository);
  final breedImageState = BreedImageState(repository: catRepository);

  runApp(
    CatinderApp(
      authState: authState,
      homeState: homeState,
      breedsListState: breedsListState,
      breedImageState: breedImageState,
      showOnboarding: showOnboarding,
      isLoggedIn: isLoggedIn,
    ),
  );
}

enum _AppScreen { onboarding, login, signUp, main }

class CatinderApp extends StatefulWidget {
  final AuthState authState;
  final HomeState homeState;
  final BreedsListState breedsListState;
  final BreedImageState breedImageState;
  final bool showOnboarding;
  final bool isLoggedIn;

  const CatinderApp({
    super.key,
    required this.authState,
    required this.homeState,
    required this.breedsListState,
    required this.breedImageState,
    required this.showOnboarding,
    required this.isLoggedIn,
  });

  @override
  State<CatinderApp> createState() => _CatinderAppState();
}

class _CatinderAppState extends State<CatinderApp> {
  late _AppScreen _screen;

  @override
  void initState() {
    super.initState();
    if (widget.showOnboarding) {
      _screen = _AppScreen.onboarding;
    } else if (!widget.isLoggedIn) {
      _screen = _AppScreen.login;
    } else {
      _screen = _AppScreen.main;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: switch (_screen) {
        _AppScreen.onboarding => OnboardingScreen(
          onComplete: () => setState(() => _screen = _AppScreen.login),
        ),
        _AppScreen.login => LoginScreen(
          authState: widget.authState,
          onLoginSuccess: () => setState(() => _screen = _AppScreen.main),
          onGoToSignUp: () => setState(() {
            widget.authState.clearError();
            _screen = _AppScreen.signUp;
          }),
        ),
        _AppScreen.signUp => SignUpScreen(
          authState: widget.authState,
          onSignUpSuccess: () => setState(() => _screen = _AppScreen.main),
          onGoToLogin: () => setState(() {
            widget.authState.clearError();
            _screen = _AppScreen.login;
          }),
        ),
        _AppScreen.main => IndexedStackScreen(
          homeState: widget.homeState,
          breedsListState: widget.breedsListState,
          breedImageState: widget.breedImageState,
        ),
      },
    );
  }
}

// flutter run -d chrome --web-browser-flag="--disable-web-security" --dart-define-from-file=env.json

import 'package:flutter/foundation.dart';

import '../../domain/models/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';

class HomeState extends ChangeNotifier {
  final CatRepository _repository;

  HomeState({required CatRepository repository}) : _repository = repository {
    loadNextImage();
  }

  int _likesCount = 0;
  int get likesCount => _likesCount;

  CatImage? _currentImage;
  CatImage? get currentImage => _currentImage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  void clearError() {
    _error = null;
  }

  Future<void> loadNextImage() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentImage = await _repository.getRandomCatImage();
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void like() {
    _likesCount++;
    loadNextImage();
  }

  void dislike() {
    loadNextImage();
  }
}

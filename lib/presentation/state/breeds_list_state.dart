import 'package:flutter/foundation.dart';

import '../../domain/models/breed.dart';
import '../../domain/repositories/cat_repository.dart';

class BreedsListState extends ChangeNotifier {
  final CatRepository _repository;

  BreedsListState({required CatRepository repository})
    : _repository = repository {
    loadBreeds();
  }

  List<Breed> _breeds = [];
  List<Breed> get breeds => _breeds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Object? _error;
  Object? get error => _error;

  void clearError() {
    _error = null;
  }

  Future<void> loadBreeds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _breeds = await _repository.getAllBreeds();
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/foundation.dart';

import '../../domain/models/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';

class BreedImageState extends ChangeNotifier {
  final CatRepository _repository;

  BreedImageState({required CatRepository repository})
      : _repository = repository;

  final Map<String, CatImage> _cache = {};
  final Map<String, Object> _errors = {};
  final Set<String> _loading = {};

  bool isLoading(String imageId) => _loading.contains(imageId);
  Object? errorFor(String imageId) => _errors[imageId];
  CatImage? imageFor(String imageId) => _cache[imageId];

  Future<void> load(String imageId) async {
    if (_cache.containsKey(imageId) || _loading.contains(imageId)) return;

    _loading.add(imageId);
    notifyListeners();

    try {
      _cache[imageId] = await _repository.getCatImageById(imageId);
    } catch (e) {
      _errors[imageId] = e;
    } finally {
      _loading.remove(imageId);
      notifyListeners();
    }
  }
}

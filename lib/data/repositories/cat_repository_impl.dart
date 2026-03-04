import '../../domain/models/breed.dart';
import '../../domain/models/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_api_datasource.dart';

/// Concrete implementation of [CatRepository] backed by [CatApiDatasource].
class CatRepositoryImpl implements CatRepository {
  final CatApiDatasource _datasource;

  CatRepositoryImpl({required CatApiDatasource datasource})
      : _datasource = datasource;

  @override
  Future<CatImage> getRandomCatImage() async {
    final imageId = await _datasource.fetchRandomImageId();
    return _datasource.fetchImageData(imageId);
  }

  @override
  Future<CatImage> getCatImageById(String imageId) {
    return _datasource.fetchImageData(imageId);
  }

  @override
  Future<List<Breed>> getAllBreeds() {
    return _datasource.fetchAllBreeds();
  }
}

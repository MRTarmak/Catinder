import '../models/breed.dart';
import '../models/cat_image.dart';

abstract class CatRepository {
  /// Fetches a random cat image that has breed info.
  Future<CatImage> getRandomCatImage();

  /// Fetches image data by [imageId].
  Future<CatImage> getCatImageById(String imageId);

  /// Fetches the full list of breeds.
  Future<List<Breed>> getAllBreeds();
}

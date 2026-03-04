import 'breed.dart';

class CatImage {
  final String id;
  final String url;
  final List<Breed> breeds;

  const CatImage({required this.id, required this.url, this.breeds = const []});
}

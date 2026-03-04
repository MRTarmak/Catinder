class Breed {
  final String id;
  final String name;
  final String description;
  final String? weight;
  final String? lifeSpan;
  final String? temperament;
  final String? referenceImageId;

  const Breed({
    required this.id,
    required this.name,
    required this.description,
    this.weight,
    this.lifeSpan,
    this.temperament,
    this.referenceImageId,
  });
}

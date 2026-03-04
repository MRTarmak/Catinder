import 'package:flutter/material.dart';

import '../../domain/models/breed.dart';
import '../screens/details_screen.dart';
import '../state/breed_image_state.dart';

class BreedCard extends StatefulWidget {
  final Breed breed;
  final BreedImageState imageState;

  const BreedCard({super.key, required this.breed, required this.imageState});

  @override
  State<BreedCard> createState() => _BreedCardState();
}

class _BreedCardState extends State<BreedCard> {
  @override
  void initState() {
    super.initState();
    widget.imageState.addListener(_onStateChanged);
    final imageId = widget.breed.referenceImageId;
    if (imageId != null && imageId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.imageState.load(imageId);
      });
    }
  }

  @override
  void dispose() {
    widget.imageState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final imageId = widget.breed.referenceImageId;
    Widget imageWidget;

    if (imageId == null || imageId.isEmpty) {
      imageWidget = Center(
        child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
      );
    } else if (widget.imageState.isLoading(imageId)) {
      imageWidget = Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(),
        ),
      );
    } else if (widget.imageState.errorFor(imageId) != null) {
      imageWidget = Center(
        child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
      );
    } else {
      final catImage = widget.imageState.imageFor(imageId);
      if (catImage != null) {
        imageWidget = Image.network(
          catImage.url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
          ),
          loadingBuilder: (_, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        );
      } else {
        imageWidget = Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ),
        );
      }
    }

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: () {
            final catImage = imageId != null
                ? widget.imageState.imageFor(imageId)
                : null;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsScreen(
                  image: (catImage != null)
                      ? Image.network(catImage.url, fit: BoxFit.cover)
                      : null,
                  breedName: widget.breed.name,
                  description: widget.breed.description,
                  weight: widget.breed.weight,
                  lifespan: widget.breed.lifeSpan,
                  temperament: widget.breed.temperament,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Positioned.fill(child: imageWidget),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black, Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Text(
                  widget.breed.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

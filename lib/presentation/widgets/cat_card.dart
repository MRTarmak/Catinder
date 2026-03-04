import 'package:flutter/material.dart';

import '../../domain/models/cat_image.dart';
import '../screens/details_screen.dart';

class CatCard extends StatelessWidget {
  final CatImage catImage;

  const CatCard({super.key, required this.catImage});

  @override
  Widget build(BuildContext context) {
    final breedName = catImage.breeds.isNotEmpty
        ? catImage.breeds.first.name
        : 'Unknown';

    final image = Image.network(
      catImage.url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
      loadingBuilder: (context, child, loadingProgress) {
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

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsScreen.fromCatImage(
                  catImage: catImage,
                  image: image,
                ),
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(child: image),
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
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Text(
                    breedName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

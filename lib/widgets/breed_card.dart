import 'package:flutter/material.dart';

import '../screens/details_screen.dart';
import '../utils/fetch_image_data.dart';

class BreedCard extends StatelessWidget {
  final Map<String, dynamic> breedData;

  final ValueChanged<Object?>? onError;

  const BreedCard({super.key, required this.breedData, this.onError});

  @override
  Widget build(BuildContext context) {
    final imageId = breedData['reference_image_id'] as String?;
    final imageDataFuture = (imageId != null && imageId.isNotEmpty)
        ? fetchImageData(imageId)
        : Future.value(<String, dynamic>{});

    final breedName = breedData['name'] ?? 'Unknown';
    final description = breedData['description'] ?? '';

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: FutureBuilder<Map<String, dynamic>>(
          future: imageDataFuture,
          builder: (context, snapshot) {
            Widget imageWidget;

            if (snapshot.connectionState == ConnectionState.waiting) {
              imageWidget = Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onError?.call(snapshot.error);
              });

              imageWidget = Center(
                child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
              );
            } else if (snapshot.hasData) {
              final imageUrl = snapshot.data?['url'] as String?;
              if (imageUrl != null && imageUrl.isNotEmpty) {
                imageWidget = Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
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
              } else {
                imageWidget = Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Colors.grey,
                  ),
                );
              }
            } else {
              throw Exception("Unexpected state in FutureBuilder");
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      image: imageWidget is Image ? imageWidget : null,
                      breedName: breedName,
                      description: description,
                      weight: breedData['weight']?['metric'],
                      lifespan: breedData['life_span'],
                      temperament: breedData['temperament'],
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
                      breedName,
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
            );
          },
        ),
      ),
    );
  }
}

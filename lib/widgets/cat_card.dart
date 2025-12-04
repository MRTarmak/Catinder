import 'package:flutter/material.dart';

import '../screens/details_screen.dart';

class CatCard extends StatelessWidget {
  final Future<Map<String, dynamic>> _dataFuture;

  const CatCard({super.key, required Future<Map<String, dynamic>> dataFuture})
    : _dataFuture = dataFuture;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // TODO adjust card size for different screen sizes
      aspectRatio: 3 / 4,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
          bottom: 8.0,
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: FutureBuilder(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Error: ${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                final image = Image.network(
                  snapshot.data!['url'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Error: image failed to load.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                );
                final breedName = snapshot.data!['breeds'][0]['name'];
                final description = snapshot.data!['breeds'][0]['description'];

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        image: image,
                        breedName: breedName,
                        description: description,
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
                );
              }
              throw Exception("Unexpected state in FutureBuilder");
            },
          ),
        ),
      ),
    );
  }
}
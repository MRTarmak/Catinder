import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Image? image;
  final String breedName;
  final String description;

  final String? weight;
  final String? lifespan;
  final String? temperament;

  const DetailsScreen({
    super.key,
    this.image,
    required this.breedName,
    required this.description,
    this.weight,
    this.lifespan,
    this.temperament,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Catinder",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (image != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: image!,
                            ),
                          SizedBox(height: 12),
                          Text(
                            breedName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 12),
                          if (weight != null)
                            Text(
                              "Weight: $weight kg",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          if (lifespan != null)
                            Text(
                              "Lifespan: $lifespan years",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          if (temperament != null)
                            Text(
                              "Temperament: $temperament",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            child: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

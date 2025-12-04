import 'package:flutter/material.dart';

class BreedListPage extends StatelessWidget {
  const BreedListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Card(child: Text("Breed ${index * 2}")),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Card(child: Text("Breed ${index * 2 + 1}")),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
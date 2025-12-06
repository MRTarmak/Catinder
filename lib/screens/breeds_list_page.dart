import 'dart:convert';

import 'package:catinder/widgets/breed_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BreedsListPage extends StatefulWidget {
  const BreedsListPage({super.key});

  @override
  State<BreedsListPage> createState() => _BreedsListPageState();
}

class _BreedsListPageState extends State<BreedsListPage> {
  late final Future<List<dynamic>> _breedsDataFuture;

  Future<List<dynamic>> _fetchBreedsData() async {
    try {
      final response = await http.get(
        Uri.https("api.thecatapi.com", "/v1/breeds"),
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to find breeds data. Status code: ${response.statusCode}",
        );
      }

      final List<dynamic> breedsData = jsonDecode(response.body);

      return breedsData;
    } catch (e) {
      throw Exception("Did not manage to fetch data. $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _breedsDataFuture = _fetchBreedsData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _breedsDataFuture,
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
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final breedData = snapshot.data![index];
                return BreedCard(breedData: breedData);
              },
            );
          }
          throw Exception("Unexpected state in FutureBuilder");
        },
      ),
    );
  }
}

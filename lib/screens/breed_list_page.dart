import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BreedListPage extends StatefulWidget {
  const BreedListPage({super.key});

  @override
  State<BreedListPage> createState() => _BreedListPageState();
}

class _BreedListPageState extends State<BreedListPage> {
  late final Future<List<dynamic>> _breedsDataFuture;

  Future<List<dynamic>> _fetchBreedsData() async {
    try {
      final searchResponse = await http.get(
        Uri.https("api.thecatapi.com", "/v1/breeds"),
      );

      if (searchResponse.statusCode != 200) {
        throw Exception(
          "Failed to find breeds data. Status code: ${searchResponse.statusCode}",
        );
      }

      final List<dynamic> breedsData = jsonDecode(searchResponse.body);

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
            return ListView.builder(
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Card(
                          child: Text(snapshot.data![index * 2]['name']),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: snapshot.data!.length > index * 2 + 1
                            ? Card(
                                child: Text(
                                  snapshot.data![index * 2 + 1]['name'],
                                ),
                              )
                            : SizedBox(),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          throw Exception("Unexpected state in FutureBuilder");
        },
      ),
    );
  }
}

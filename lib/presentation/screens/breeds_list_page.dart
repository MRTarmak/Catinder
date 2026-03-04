import 'package:flutter/material.dart';

import '../state/breed_image_state.dart';
import '../state/breeds_list_state.dart';
import '../utils/dialogs.dart';
import '../widgets/breed_card.dart';

class BreedsListPage extends StatefulWidget {
  final BreedsListState state;
  final BreedImageState imageState;

  const BreedsListPage({
    super.key,
    required this.state,
    required this.imageState,
  });

  @override
  State<BreedsListPage> createState() => _BreedsListPageState();
}

class _BreedsListPageState extends State<BreedsListPage> {
  bool _errorDialogShown = false;

  BreedsListState get _state => widget.state;

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {});

    final error = _state.error;
    if (error != null && !_errorDialogShown) {
      _errorDialogShown = true;
      showErrorDialog(context, error.toString()).then((_) {
        _errorDialogShown = false;
        _state.clearError();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state.isLoading) {
      return Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_state.error != null && _state.breeds.isEmpty) {
      return Center(
        child: Icon(Icons.error_outline, size: 48, color: Colors.grey),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _state.breeds.length,
      itemBuilder: (context, index) {
        return BreedCard(
          breed: _state.breeds[index],
          imageState: widget.imageState,
        );
      },
    );
  }
}

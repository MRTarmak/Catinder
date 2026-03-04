import 'package:flutter/material.dart';

import '../state/home_state.dart';
import '../utils/dialogs.dart';
import '../widgets/cat_card.dart';

class HomePage extends StatefulWidget {
  final HomeState state;

  const HomePage({super.key, required this.state});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _errorDialogShown = false;

  HomeState get _state => widget.state;

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

    // Show error dialog once when an error comes in.
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
    final catImage = _state.currentImage;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.red),
            Text(' ${_state.likesCount}'),
          ],
        ),
        Expanded(
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                _state.dislike();
              } else {
                _state.like();
              }
            },
            child: Center(
              child: _state.isLoading || catImage == null
                  ? AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Card(
                          child: Center(
                            child: _state.error != null
                                ? Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.grey,
                                  )
                                : SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                      ),
                    )
                  : CatCard(catImage: catImage),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'like',
              onPressed: () => _state.like(),
              child: Icon(Icons.thumb_up),
            ),
            SizedBox(width: 50),
            FloatingActionButton(
              heroTag: 'dislike',
              onPressed: () => _state.dislike(),
              child: Icon(Icons.thumb_down),
            ),
          ],
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

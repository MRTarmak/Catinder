import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String message) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('An error occurred'),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

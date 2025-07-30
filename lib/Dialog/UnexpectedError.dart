import 'package:flutter/material.dart';

class UnexpectedErrorDialog extends StatelessWidget {
  final String Error;

  const UnexpectedErrorDialog({super.key, required this.Error});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error),
      title: const Text('未預期的錯誤'),
      content: Text(Error),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          child: const Text('了解'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

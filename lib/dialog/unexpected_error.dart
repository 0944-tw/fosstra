import 'package:flutter/material.dart';

class UnexpectedErrorDialog extends StatelessWidget {
  final String errorMessage;

  const UnexpectedErrorDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error),
      title: const Text('未預期的錯誤'),
      content: Text(errorMessage),
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

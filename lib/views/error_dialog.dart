import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showErrorDialog(
    {required BuildContext context, String title = "", String text = ""}) {
  showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(title: title, text: text);
      });
}

class ErrorDialog extends StatelessWidget {
  final String title;
  final String text;

  const ErrorDialog({super.key, required this.title, required this.text});

  dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
            onPressed: () {
              dismiss(context);
            },
            child: const Text("Ok"))
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../color/my_color.dart';

class MyAlertDialog extends StatelessWidget{

  final String title;
  final String content;
  final String? negative;
  final void Function()? negativeAction;
  final String positive;
  final void Function()? positiveAction;

  const MyAlertDialog({required this.title, required this.content, required this.positive, this.negative, this.negativeAction, this.positiveAction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: MyColor.primaryColor, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      content: Text(content),
      actions: [
        if (negative != null) TextButton(
            onPressed: negativeAction,
            child: Text(negative!, style: const TextStyle(color: Colors.grey))
        ),
        TextButton(
            onPressed: positiveAction,
            child: Text(positive, style: const TextStyle(color: MyColor.primaryColor)))
      ],
    );
  }
}
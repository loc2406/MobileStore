import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySimpleDialog extends StatelessWidget {
  const MySimpleDialog({super.key, required this.title, required this.items});

  final String title;
  final List<MySimpleDialogItem> items;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: items,
    );
  }
}

class MySimpleDialogItem extends StatelessWidget {
  const MySimpleDialogItem({super.key, required this.icon, required this.text, required this.onPressed});

  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

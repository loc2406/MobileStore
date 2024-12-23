import 'package:flutter/material.dart';

class MyWidget{
  static SnackBar getSnackBar(String message){
    return SnackBar(content: Text(message), duration: const Duration(seconds: 2));
  }
}
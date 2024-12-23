import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../color/my_color.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final void Function()? suffixIconClicked;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isObscure;
  final String? Function(String?) validateMethod;

  const InputField({super.key,
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.prefixIcon,
    required this.validateMethod,
    this.isObscure = false,
    this.suffixIcon,
    this.suffixIconClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            // call() là phương thức đặc biệt cho phép gọi 1 function object như 1 hàm thông thường khi có tham chiếu
              prefixIcon: Icon(prefixIcon, color: Colors.black),
              suffixIcon: suffixIcon != null ? IconButton(
                icon: Icon(suffixIcon),
                color: Colors.black,
                onPressed: suffixIconClicked,
              ) : null,
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: MyColor.primaryColor)),
              errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: MyColor.errColor, style: BorderStyle.solid)),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: MyColor.primaryColor)),
              focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: MyColor.errColor))),
          validator: validateMethod,
          // Validate khi người dùng nhập liệu
          keyboardType: keyboardType,
          obscureText: isObscure,
        ));
  }
}

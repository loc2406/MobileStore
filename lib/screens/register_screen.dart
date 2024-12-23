import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:mobile_store/cubit/account/account_cubit.dart';
import 'package:mobile_store/utils/color/my_color.dart';
import 'package:mobile_store/utils/method/my_method.dart';
import 'package:mobile_store/utils/widget/my_input_field.dart';
import 'package:http/http.dart' as http;

import '../apis/user.dart';
import '../models/user.dart';
import '../utils/sharedref/my_shared_ref.dart';
import '../utils/widget/my_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final key = GlobalKey();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isHidePassword = true;
  bool isHideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        decoration: BoxDecoration(
            border: const Border.fromBorderSide(
                BorderSide(color: MyColor.primaryColor)),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Register',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
            Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    label: 'Username',
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.text,
                    controller: userNameController,
                    validateMethod: MyMethod.validateName,
                  ),
                  InputField(
                    label: 'Name',
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    validateMethod: MyMethod.validateName,
                  ),
                  InputField(
                    label: 'Password',
                    prefixIcon: Icons.lock,
                    suffixIcon: isHidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    isObscure: isHidePassword ? true : false,
                    suffixIconClicked: () {
                      setState(() {
                        isHidePassword = !isHidePassword;
                      });
                    },
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    validateMethod: MyMethod.validatePassword,
                  ),
                  InputField(
                    label: 'Confirm password',
                    prefixIcon: Icons.lock,
                    suffixIcon: isHideConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    isObscure: isHideConfirmPassword ? true : false,
                    suffixIconClicked: () {
                      setState(() {
                        isHideConfirmPassword = !isHideConfirmPassword;
                      });
                    },
                    keyboardType: TextInputType.text,
                    controller: confirmController,
                    validateMethod: (value) => MyMethod.validateConfirmPassword(
                        passwordController.text, value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(MyColor.primaryColor),
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 50))),
                onPressed: handleRegister,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You had an account before?'),
                TextButton(
                    child: const Text('Login',
                        style: TextStyle(color: MyColor.primaryColor)),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            )
          ],
        ),
      )),
    );
  }

  Future<void> handleRegister() async {
    if ((key.currentState as FormState).validate()) {
      try {
        Response response = await context.read<AccountCubit>().handleRegister(userNameController.text, nameController.text, passwordController.text);

        if (mounted) {
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context)
                .showSnackBar(MyWidget.getSnackBar('Register successful!'));
            Navigator.pop(context, true);
          } else if (response.statusCode == 400 &&
              response.body.contains('Username already exists')) {
            ScaffoldMessenger.of(context)
                .showSnackBar(MyWidget.getSnackBar(response.body));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(MyWidget.getSnackBar('Register failed!'));
          }
        }
      } catch (e) {
        debugPrint('HANDLE REGISTER ===== err: $e');
      }
    }
  }
}

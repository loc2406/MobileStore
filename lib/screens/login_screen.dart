import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:mobile_store/cubit/account/account_cubit.dart';
import 'package:mobile_store/parent.dart';
import 'package:mobile_store/screens/register_screen.dart';
import 'package:mobile_store/utils/color/my_color.dart';
import 'package:mobile_store/utils/method/my_method.dart';
import 'package:mobile_store/utils/sharedref/my_shared_ref.dart';
import 'package:mobile_store/utils/widget/my_widget.dart';
import 'package:mobile_store/utils/widget/my_input_field.dart';
import 'package:http/http.dart' as http;

import '../apis/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey key = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isHidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              border: const Border.fromBorderSide(
                  BorderSide(color: MyColor.primaryColor)),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Login',
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
                      controller: usernameController,
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
                  onPressed: handleLogin,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You don\'t have account?'),
                  TextButton(
                      child: const Text('Register',
                          style: TextStyle(color: MyColor.primaryColor)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleLogin() async {
    if ((key.currentState as FormState).validate()) {
      try {
        final Response response = await context.read<AccountCubit>().handleLogin(usernameController.text, passwordController.text);

        if (mounted){
          if(response.statusCode ==200) {
            final token = response.body;
            MySharedRef.setToken(token);

            ScaffoldMessenger.of(context)
                .showSnackBar(MyWidget.getSnackBar('Login successful!'));

            Navigator.pop(context, true);
          }else{
            Map<String, dynamic> err = jsonDecode(response.body);
            var errDetail = '';
            if (err.containsKey('details')){
              errDetail = err['details'].toString();
            }

            ScaffoldMessenger.of(context)
                .showSnackBar(MyWidget.getSnackBar('Login failed! $errDetail'));
          }
        }
      } catch (e) {
        debugPrint('HANDLE LOGIN ===== err: $e');
      }
    }
  }
}

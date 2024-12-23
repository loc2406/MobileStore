import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/cubit/account/account_cubit.dart';
import 'package:mobile_store/cubit/screen/screen_cubit.dart';

import 'cubit/cart/cart_cubit.dart';
import 'cubit/product/product_cubit.dart';
import 'parent.dart';

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainState();
}

class _MainState extends State<MainScreen> {

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => AccountCubit()),
        BlocProvider(create: (context) => ScreenCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ParentScreen(),
      ),
    );
  }

  // Future<void> _checkIsLoggedIn() async {
  //   final sharedPref = await SharedPreferences.getInstance();
  //   setState(() {
  //     isLoggedIn = sharedPref.getBool('is_logged_in') ?? false;
  //   });
  // }
}
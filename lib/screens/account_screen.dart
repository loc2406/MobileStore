import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/cubit/account/error_state.dart';
import 'package:mobile_store/cubit/account/initial_state.dart';
import 'package:mobile_store/cubit/account/loading_state.dart';
import 'package:mobile_store/cubit/account/no_logged_in_state.dart';
import 'package:mobile_store/cubit/account/success_state.dart';
import 'package:mobile_store/cubit/account/token_has_expired_state.dart';
import 'package:mobile_store/screens/login_screen.dart';
import 'package:mobile_store/utils/sharedref/my_shared_ref.dart';

import '../cubit/account/account_cubit.dart';
import '../cubit/account/account_state.dart';
import '../models/user.dart';
import '../utils/color/my_color.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: MyColor.appBarBackgroundColor,
          flexibleSpace: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Account',
                  style: TextStyle(
                      color: MyColor.appBarTitleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 32),
                ),
                Text(
                  'Show your account\'s information',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
        if (state is InitialState || state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NoLoggedInState || state is TokenHasExpiredState) {
          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(state is NoLoggedInState
                  ? 'You don\'t logged in before!'
                  : 'You need logged in again to continue using app!'),
              ElevatedButton(
                  onPressed: () async {
                    bool isLoggedIn = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));

                    if (isLoggedIn) fetchUser();
                  },
                  child: const Text('Login'))
            ]),
          );
        } else if (state is ErrorState) {
          return Center(child: Text(state.errorMessage));
        } else if (state is SuccessState) {
          User user = state.user;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.network(
                  'https://cdn2.cellphones.com.vn/x/media/catalog/product/i/p/iphone11-purple-select-2019_2_1_2_2_3.png',
                  width: 150),
              const SizedBox(height: 30),
              Text(user.userName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('ID: ${user.id}',
                  style: const TextStyle(color: Colors.black, fontSize: 14)),
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.account_circle,
                    color: MyColor.primaryColor,
                  ),
                  const SizedBox(width: 20),
                  Text('Full name: ${user.name}',
                      style: const TextStyle(color: Colors.black, fontSize: 14))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.shield,
                    color: MyColor.primaryColor,
                  ),
                  const SizedBox(width: 20),
                  Text('Role: ${user.role}',
                      style: const TextStyle(color: Colors.black, fontSize: 14))
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    bool isLoggedOut = await MySharedRef.setToken('');
                    if (isLoggedOut && mounted) this.context.read<AccountCubit>().setLogoutState();
                  },
                  child: const Text('Logout'))
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  void fetchUser() {
    context.read<AccountCubit>().fetchUser();
  }
}

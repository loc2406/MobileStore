import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/bottom_nav/custom_bottom_nav.dart';
import 'package:mobile_store/cubit/screen/initial_state.dart';
import 'package:mobile_store/cubit/screen/screen_cubit.dart';
import 'package:mobile_store/cubit/screen/selected_state.dart';
import 'package:mobile_store/screens/account_screen.dart';
import 'package:mobile_store/screens/cart_screen.dart';
import 'package:mobile_store/screens/home_screen.dart';
import 'package:mobile_store/screens/login_screen.dart';
import 'package:mobile_store/screens/register_screen.dart';
import 'package:mobile_store/utils/color/my_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/screen/screen_state.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {

  @override
  void initState() {
    super.initState();
    selectScreen(0);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenCubit, ScreenState>(builder: (context, state){
      if (state is SelectedState){
        return Scaffold(body: state.selectedScreen, bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: state.selectedIndex,
            onItemSelected: (index) {
              selectScreen(index);
            }),
        );
      }else{
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    }) ;
  }

  void selectScreen(int index){
    context.read<ScreenCubit>().selectScreen(index);
  }
}

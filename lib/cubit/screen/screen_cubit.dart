import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/cubit/screen/screen_state.dart';

import '../../screens/account_screen.dart';
import '../../screens/cart_screen.dart';
import '../../screens/home_screen.dart';

class ScreenCubit extends Cubit<ScreenState> {
  final List<Widget> screens = [
    const HomeScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  ScreenCubit() : super(ScreenState.initial());

  selectScreen(int index) async {
    emit(ScreenState.select(index, screens[index]));
  }
}

import 'package:flutter/cupertino.dart';

import 'screen_state.dart';

class SelectedState extends ScreenState {
  final int selectedIndex;
  final Widget selectedScreen;

  SelectedState(this.selectedIndex, this.selectedScreen);
}

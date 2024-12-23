import 'package:flutter/material.dart';
import 'package:mobile_store/cubit/screen/selected_state.dart';

import 'initial_state.dart';

class ScreenState {
  const ScreenState();

  factory ScreenState.initial() => InitialState();

  factory ScreenState.select(int index, Widget screen) => SelectedState(index, screen);
}

import 'package:mobile_store/cubit/cart/cart_state.dart';

class ErrorState extends CartState {
  final String errorMessage;

  const ErrorState(this.errorMessage);
}

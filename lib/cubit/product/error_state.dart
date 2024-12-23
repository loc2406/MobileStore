
import 'package:mobile_store/cubit/product/product_state.dart';

class ErrorState extends ProductState {
  final String errorMessage;

  const ErrorState(this.errorMessage);
}
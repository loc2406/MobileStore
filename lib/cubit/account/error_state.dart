import 'package:mobile_store/cubit/product/product_state.dart';

import 'account_state.dart';

class ErrorState extends AccountState {
  final String errorMessage;

  const ErrorState(this.errorMessage);
}

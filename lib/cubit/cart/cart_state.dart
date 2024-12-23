import 'package:mobile_store/cubit/cart/error_state.dart';
import 'package:mobile_store/cubit/cart/initial_state.dart';
import 'package:mobile_store/cubit/cart/loading_state.dart';
import 'package:mobile_store/cubit/cart/success_state.dart';

import '../../models/cart_product.dart';
import '../../models/product.dart';

class CartState {
  const CartState();

  factory CartState.initial() => InitialState();

  factory CartState.loading() => LoadingState();

  factory CartState.success(List<CartProduct> productInCart) =>
      SuccessState(productInCart);

  factory CartState.error(String errorMessage) => ErrorState(errorMessage);
}

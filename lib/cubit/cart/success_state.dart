import '../../models/cart_product.dart';
import 'cart_state.dart';

class SuccessState extends CartState {
  final List<CartProduct> productsInCart;

  SuccessState(this.productsInCart);
}

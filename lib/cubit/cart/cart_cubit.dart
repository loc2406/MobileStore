import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/cubit/cart/cart_state.dart';
import 'package:mobile_store/models/product.dart';

import '../../apis/order.dart';
import '../../models/cart_product.dart';
import '../../utils/sharedref/my_shared_ref.dart';
import 'package:http/http.dart' as http;

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  fetchCart() async {
    try {
      emit(CartState.loading());
      var cart = await MySharedRef.getAllProducts();

      if (cart.isEmpty){
        emit(CartState.initial());
      }else{
        emit(CartState.success(cart));
      }
    } catch (e) {
      emit(
        CartState.error("Error loading products in cart: $e"),
      );
    }
  }

   setClearCartState() {
    emit(CartState.initial());
   }

  addToCart(Product product) async {
    return await MySharedRef.addProductInCart(product);
  }

  removeProductFromCart(int productId) async {
    return await MySharedRef.removeProductInCart(productId);
  }

  clearCart() async {
    return await MySharedRef.removeAllProducts();
  }

  handleCheckout({
    required int grandTotal,
    required int paymentMethodId,
    required List<Map<String, dynamic>> cartDetails,
    required String token,
  }) async {
    final Map<String, dynamic> body = {
      'total': grandTotal,
      'paymentMethod': paymentMethodId,
      'orderStatus': 1,
      'details': cartDetails
    };

    return await http.post(Uri.parse(OrderAPI.addNewOrder),
        body: jsonEncode(body),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8'
        });
  }
}

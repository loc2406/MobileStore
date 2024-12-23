import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cart_product.dart';
import '../../models/product.dart';

class MySharedRef {
  static SharedPreferences? sharedRef;
  static String cartRef = 'cart';
  static String loginStateRef = 'loginState';
  static String tokenRef = 'token';
  static String userIdRef = 'userId';
  static String loggedTimeRef = 'loggedTime';

  static Future<void> _init() async {
    sharedRef = await SharedPreferences.getInstance();
  }

  static Future<bool> addProductInCart(Product product) async {
    var cart = await getAllProducts();
    final productIndex = cart.indexWhere((p) => p.productId == product.id);
    if (productIndex != -1) {
      cart[productIndex].quantity += 1;
    } else {
      cart.add(CartProduct(
          productId: product.id,
          productName: product.name,
          quantity: 1,
          unitPrice: product.price));
    }
    var listMap = cart.map((product) => product.toJson()).toList();
    var jsonList = json.encode(listMap);
    return await sharedRef!.setString(cartRef, jsonList);
  }

  static Future<bool> removeProductInCart(int productId) async {
    var cart = await getAllProducts();
    cart.removeWhere((p) => p.productId == productId);
    var listMap = cart.map((product) => product.toJson()).toList();
    var jsonList = json.encode(listMap);
    return await sharedRef!.setString(cartRef, jsonList);
  }

  static Future<bool> removeAllProducts() async {
    if (sharedRef == null) await _init();
    var jsonList = json.encode([]);
    return await sharedRef!.setString(cartRef, jsonList);
  }

  static Future<List<CartProduct>> getAllProducts() async {
    if (sharedRef == null) await _init();
    var cartJson = sharedRef!.getString(cartRef) ?? '[]';
    List<dynamic> cart = json.decode(cartJson);
    return cart
        .map((map) => CartProduct.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  static Future<String?> getToken() async {
    if (sharedRef == null) await _init();
    return sharedRef!.getString(tokenRef);
  }

  static Future<bool> setToken(String token) async {
    if (sharedRef == null) await _init();
    return sharedRef!.setString(tokenRef, token);
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mobile_store/apis/order.dart';
import 'package:mobile_store/cubit/cart/cart_cubit.dart';
import 'package:mobile_store/cubit/cart/error_state.dart';
import 'package:mobile_store/cubit/cart/initial_state.dart';
import 'package:mobile_store/cubit/cart/loading_state.dart';
import 'package:mobile_store/cubit/cart/success_state.dart';
import 'package:mobile_store/cubit/screen/screen_cubit.dart';
import 'package:mobile_store/screens/login_screen.dart';
import 'package:mobile_store/utils/dialog/alert/my_alert_dialog.dart';
import 'package:mobile_store/utils/dialog/simple/my_simple_dialog.dart';
import 'package:mobile_store/utils/exception/token_has_expired_exception.dart';
import 'package:mobile_store/utils/color/my_color.dart';
import 'package:mobile_store/utils/method/my_method.dart';
import 'package:mobile_store/utils/sharedref/my_shared_ref.dart';
import 'package:mobile_store/utils/style/my_text_style.dart';
import 'package:mobile_store/utils/widget/my_widget.dart';

import '../cubit/cart/cart_state.dart';
import '../models/cart_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartProduct> cart = [];
  int grandTotal = 0;
  late final CartCubit cartCubit;

  @override
  void initState() {
    super.initState();
    cartCubit = context.read<CartCubit>();
    fetchProducts();
  }

  void fetchProducts() {
    cartCubit.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: MyColor.appBarBackgroundColor,
          flexibleSpace: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cart',
                  style: TextStyle(
                      color: MyColor.appBarTitleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 32),
                ),
                Text(
                  'All products selected are in your cart',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
        if (state is InitialState) {
          // cart is empty
          return const Center(
            child: Text('You don\'t have any product in cart!'),
          );
        } else if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorState) {
          return Center(
            child: Text('Error: ${state.errorMessage}'),
          );
        } else if (state is SuccessState) {
          cart = state.productsInCart;
          grandTotal = 0;

          return Column(
            children: [
              const SizedBox(height: 15.36),
              Table(
                children: [
                  TableRow(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColor.tableBorderBottomColor))),
                      children: [
                        TableCell(
                            child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: const BoxDecoration(
                              color: MyColor.tableHeaderBackgroundColor),
                          child: const Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    '',
                                    style: MyTextStyle.cartTitle,
                                  )),
                              Expanded(
                                  flex: 4,
                                  child: Text('Product',
                                      style: MyTextStyle.cartTitle)),
                              Expanded(
                                  flex: 1,
                                  child: Text('Qty',
                                      style: MyTextStyle.cartTitle)),
                              Expanded(
                                  flex: 2,
                                  child: Text('Unit Price',
                                      style: MyTextStyle.cartTitle)),
                              Expanded(
                                  flex: 2,
                                  child: Text('Price',
                                      style: MyTextStyle.cartTitle))
                            ],
                          ),
                        ))
                      ]),
                  ...buildProductRows(),
                  TableRow(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: MyColor.tableBorderBottomColor))),
                      children: [
                        TableCell(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  right: 10, top: 8, bottom: 8),
                              child: Text('GrandTotal: \$$grandTotal',
                                  textAlign: TextAlign.right,
                                  style: MyTextStyle.cartTotal)),
                        )
                      ])
                ],
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 100),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: showConfirmClearCart,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 15,
                        ),
                        Text('Clear Cart',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 100),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: showPaymentMethodsDialog,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 15,
                        ),
                        Text('Check out',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 100),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: () {
                      this.context.read<ScreenCubit>().selectScreen(0);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_circle_left,
                          color: Colors.white,
                          size: 15,
                        ),
                        Text('Continue Shoping',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white))
                      ],
                    )),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  List<TableRow> buildProductRows() {
    return cart.map((product) {
      final price = product.unitPrice * product.quantity;
      grandTotal += price;
      return TableRow(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: MyColor.tableBorderBottomColor))),
          children: [
            TableCell(
                child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () => handleRemoveFromCart(product),
                      icon: const Icon(Icons.close, size: 24),
                      color: MyColor.btnClearCartColor,
                      padding: EdgeInsets.zero,
                    )),
                Expanded(
                    flex: 4,
                    child: Text(product.productName,
                        style: MyTextStyle.cartContent)),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Text('${product.quantity}',
                          style: MyTextStyle.cartContent),
                    )),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Text('${product.unitPrice}',
                          style: MyTextStyle.cartContent),
                    )),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Text('${product.unitPrice * product.quantity}',
                          style: MyTextStyle.cartContent),
                    ))
              ],
            ))
          ]);
    }).toList();
  }

  void handleRemoveFromCart(CartProduct product) {
    showDialog(
        context: context,
        builder: (context) => MyAlertDialog(
            title: 'Remove from cart?',
            content: 'Do you want remove ${product.productName} from cart?',
            negative: 'No',
            negativeAction: () {
              Navigator.pop(context);
            },
            positive: 'Yes',
            positiveAction: () async {
              Navigator.pop(context);

              bool isRemoved =
                  await cartCubit.removeProductFromCart(product.productId);

              if (mounted) {
                if (isRemoved) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                      MyWidget.getSnackBar('Remove from cart successful!'));

                  fetchProducts();
                } else {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                      MyWidget.getSnackBar('Remove from cart failed!'));
                }
              }
            }));
  }

  void showConfirmClearCart() {
    showDialog(
        context: context,
        builder: (context) => MyAlertDialog(
            title: 'Clear all?',
            content: 'Do you want remove all phones from cart?',
            negative: 'No',
            negativeAction: () {
              Navigator.pop(context);
            },
            positive: 'Yes',
            positiveAction: () async {
              Navigator.pop(context);
              bool isRemoved = await cartCubit.clearCart();

              if (mounted) {
                if (isRemoved) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                      MyWidget.getSnackBar('Remove all successful!'));

                  cartCubit.setClearCartState();
                } else {
                  ScaffoldMessenger.of(this.context)
                      .showSnackBar(MyWidget.getSnackBar('Remove all failed!'));
                }
              }
            }));
  }

  Future<void> showPaymentMethodsDialog() async {
    final token = await MySharedRef.getToken();
    if (mounted) {
      if (token != null ||
          token?.isNotEmpty == true /*|| isTokenExpired == true*/) {
        showDialog(
            context: context,
            builder: (context) =>
                MySimpleDialog(title: 'Select payment method', items: [
                  MySimpleDialogItem(
                      icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/vi/f/fe/MoMo_Logo.png',
                          width: 24),
                      text: 'Momo',
                      onPressed: () => handleCheckout(0, token!)),
                  MySimpleDialogItem(
                      icon: const Icon(
                        Icons.account_balance,
                        size: 24,
                        color: Colors.blue,
                      ),
                      text: 'Bank Transfer',
                      onPressed: () => handleCheckout(1, token!)),
                  MySimpleDialogItem(
                      icon: const Icon(Icons.monetization_on,
                          size: 24, color: Colors.green),
                      text: 'Cart',
                      onPressed: () => handleCheckout(2, token!)),
                  MySimpleDialogItem(
                      icon: const Icon(Icons.credit_card,
                          size: 24, color: Colors.blue),
                      text: 'Visa',
                      onPressed: () => handleCheckout(3, token!)),
                ]));
      } else {
        showRequireLoginDialog(
            content:
                'You don\'t logged in before? Please logged in to continue checkout!');
      }
    }
  }

  Future<void> handleCheckout(int paymentMethodId, String token) async {
    Navigator.pop(context);
    try {
      final Response response = cartCubit.handleCheckout(
          grandTotal: grandTotal,
          paymentMethodId: paymentMethodId,
          cartDetails: getCartDetail(),
          token: token);

      if (mounted) {
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context)
              .showSnackBar(MyWidget.getSnackBar('Create order successful!'));

          cartCubit.setClearCartState();
        } else if (response.statusCode == 200) {
          final body = response.body;
          final Map<String, dynamic> bodyValue = jsonDecode(body);

          if (MyMethod.isTokenHasExpired(bodyValue)) {
            throw const TokenHasExpiredException();
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(MyWidget.getSnackBar('Create order failed!'));
        }
      }
    } catch (e) {
      if (e is TokenHasExpiredException) {
        showRequireLoginDialog(
            content: 'Your token has expired! Please login again!');
      } else {
        debugPrint('HANDLE CHECKOUT ===== $e');
      }
    }
  }

  List<Map<String, dynamic>> getCartDetail() {
    return cart
        .map((product) => {
              'productId': product.productId,
              'quantity': product.quantity,
              'unitPrice': product.unitPrice,
            })
        .toList();
  }

  void showRequireLoginDialog({required String content}) {
    showDialog(
        context: context,
        builder: (context) => MyAlertDialog(
            title: 'Require login!',
            content: content,
            negative: 'Cancel',
            negativeAction: () {
              Navigator.pop(context);
            },
            positive: 'Login',
            positiveAction: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }));
  }
}

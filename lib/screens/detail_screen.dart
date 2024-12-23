import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/cubit/product/product_detail_success_state.dart';
import 'package:mobile_store/cubit/product/product_state.dart';
import 'package:mobile_store/utils/widget/my_widget.dart';
import '../apis/order.dart';
import '../cubit/product/initial_state.dart';
import '../cubit/product/loading_state.dart';
import '../cubit/product/product_cubit.dart';
import '../models/product.dart';
import '../utils/color/my_color.dart';
import '../utils/dialog/alert/my_alert_dialog.dart';
import 'package:http/http.dart' as http;

import '../utils/sharedref/my_shared_ref.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final Product product;
  late final int id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id = ModalRoute.of(context)?.settings.arguments as int;
    context.read<ProductCubit>().getProductById(id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColor.appBarBackgroundColor,
            leading: const Icon(null),
            centerTitle: true,
            title: Container(
              margin: const EdgeInsets.only(
                  left: 12.5, top: 18, right: 12.5, bottom: 17),
              child: const Text(
                'Products',
                style: TextStyle(
                    color: MyColor.appBarTitleColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 32),
              ),
            ),
          ),
          body: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
            if (state is InitialState || state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductDetailSuccessState) {
              product = state.product;
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.1),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 56),
                          child: SizedBox(
                              height: 243, child: Image.network(product.image)),
                        ),
                        const SizedBox(height: 16.1),
                        Text(product.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 24),
                            textAlign: TextAlign.justify),
                        const SizedBox(height: 16.1),
                        Text(product.description,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 16.1),
                        Row(
                          children: [
                            const Text('Item code: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                            Container(
                              decoration: BoxDecoration(
                                color: MyColor.btnOrderNowColor, // Màu nền
                                borderRadius:
                                    BorderRadius.circular(5), // Bo tròn góc
                              ),
                              padding: const EdgeInsets.all(5),
                              // Padding bên trong
                              child: Text('${product.id}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            )
                          ],
                        ),
                        const SizedBox(height: 16.1),
                        Row(
                          children: [
                            const Text('Manufacturer: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            Text(product.manufacturer,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black))
                          ],
                        ),
                        const SizedBox(height: 16.1),
                        Row(
                          children: [
                            const Text('Category: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            Text(product.category,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black))
                          ],
                        ),
                        const SizedBox(height: 16.1),
                        Row(
                          children: [
                            const Text('Available units in stock: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            Text(product.quantity.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black))
                          ],
                        ),
                        const SizedBox(height: 16.1),
                        Row(
                          children: [
                            const Text('Price: ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            Text(product.price.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black))
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                      backgroundColor: MyColor.btnBackColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: navigateToHome,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.arrow_circle_left,
                                          color: Colors.white, size: 18),
                                      Text('Back',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400))
                                    ],
                                  )),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 10),
                                      backgroundColor: MyColor.btnOrderNowColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: showConfirmOrder,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.shopping_cart,
                                          color: Colors.white, size: 18),
                                      Text('Order now',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            } else {
              return const Center(child: Text('No data avalaible!'));
            }
          }),
        ),
        onWillPop: () async {
          navigateToHome();
          return false;
        });
  }

  void navigateToHome() {
    context.read<ProductCubit>().setAllProductState();
    Navigator.pop(context);
  }

  void showConfirmOrder() {
    showDialog(
        context: context,
        builder: (context) => MyAlertDialog(
            title: 'Order product?',
            content: 'Are you sure to order \"${product.name}\"?',
            negative: 'No',
            negativeAction: () {
              Navigator.pop(context);
            },
            positive: 'Yes',
            positiveAction: () async {
              Navigator.pop(context);
              var isAdded = await context.read<ProductCubit>().handleAddProductInCart(product);
              if (mounted){
                ScaffoldMessenger.of(this.context).showSnackBar(MyWidget.getSnackBar(isAdded ? 'Add to cart successful!' : 'Add to cart failed!'));
              }
            }));
  }
}

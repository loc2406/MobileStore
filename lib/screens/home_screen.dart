import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/cubit/cart/cart_cubit.dart';
import 'package:mobile_store/cubit/product/all_products_success_state.dart';
import 'package:mobile_store/cubit/product/error_state.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mobile_store/screens/detail_screen.dart';
import 'package:mobile_store/utils/color/my_color.dart';
import 'package:mobile_store/utils/sharedref/my_shared_ref.dart';

import '../cubit/product/initial_state.dart';
import '../cubit/product/loading_state.dart';
import '../cubit/product/product_cubit.dart';
import '../cubit/product/product_state.dart';
import '../utils/dialog/alert/my_alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Product> products;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: MyColor.appBarBackgroundColor,
          flexibleSpace: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Products',
                  style: TextStyle(
                      color: MyColor.appBarTitleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 32),
                ),
                Text(
                  'All available products in our store',
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
      body: BlocBuilder<ProductCubit, ProductState>(
          builder: (BuildContext context, state) {
        if (state is InitialState || state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AllProductsSuccessState) {
          products = state.products;
          if (products.isNotEmpty) {
            return buildListProductWidget(products);
          } else {
            return const Text('No data available!');
          }
        }else if (state is ErrorState){
          return  Text('Fetch products failed: ${state.errorMessage}');
        }
        else{
          return const SizedBox();
        }
      }),
    );
  }

  ListView buildListProductWidget(List<Product> products) {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          var phone = products[index];
          return buildItemPhone(phone);
        });
  }

  Widget buildItemPhone(Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
      decoration: BoxDecoration(
          border: const Border.fromBorderSide(BorderSide(color: Colors.grey)),
          borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Column(
        children: [
          SizedBox(height: 250, child: Image.network(product.image)),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 11, right: 11),
            child: Text(
              product.name,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            product.price.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.black, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Text(
            '${product.quantity} units in stock',
            style: const TextStyle(color: Colors.black, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: MyColor.btnDetailColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => navigateToDetail(product),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Căn giữa nội dung
                      children: [
                        Icon(Icons.info, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Details', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4.5), // Khoảng cách giữa 2 nút
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: MyColor.btnOrderNowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => showConfirmOrder(product),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Căn giữa nội dung
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Order now',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void fetchProduct() {
    context.read<ProductCubit>().fetchProduct();
  }

  void navigateToDetail(Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            settings: RouteSettings(arguments: product.id),
            builder: (context) =>const DetailScreen()));
  }

  void showConfirmOrder(Product product) {
    showDialog(
        context: context,
        builder: (context) => MyAlertDialog(
            title: 'Order phone?',
            content: 'Are you sure to order \"${product.name}\"?',
            negative: 'No',
            negativeAction: () {
              Navigator.pop(context);
            },
            positive: 'Yes',
            positiveAction: () async {
              Navigator.pop(context);
              var isAdded = context.read<CartCubit>().addToCart(product);
              if (mounted){
                ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text(isAdded ? 'Add to cart successful!' : 'Add to cart failed!')));
              }
            }));
  }
}


import 'package:mobile_store/cubit/product/product_state.dart';
import 'package:mobile_store/models/product.dart';

class AllProductsSuccessState extends ProductState {
  final List<Product> products;

  AllProductsSuccessState(this.products);
}
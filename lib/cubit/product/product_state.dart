
import 'package:mobile_store/cubit/product/all_products_success_state.dart';
import 'package:mobile_store/cubit/product/product_detail_success_state.dart';
import 'package:mobile_store/models/product.dart';

import 'error_state.dart';
import 'initial_state.dart';
import 'loading_state.dart';

class ProductState {
  const ProductState();

  factory ProductState.initial() => InitialState();

  factory ProductState.loading() => LoadingState();

  factory ProductState.successAll(List<Product> products) => AllProductsSuccessState(products);

  factory ProductState.successOnly(Product phone) => ProductDetailSuccessState(phone);

  factory ProductState.error(String errorMessage) => ErrorState(errorMessage);
}

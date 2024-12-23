import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/apis/product.dart';
import 'package:mobile_store/cubit/product/product_state.dart';

import '../../models/product.dart';
import '../../utils/sharedref/my_shared_ref.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductState.initial());

  List<Product> allProducts = [];

  fetchProduct() async {
    try {
      emit(ProductState.loading());
      List<Product> allProducts = await PhoneAPI.getAllProducts();
      if (allProducts.isNotEmpty){
        this.allProducts = allProducts;
        emit(ProductState.successAll(allProducts));
      }
    } catch (e) {
      emit(
        ProductState.error("Error loading all products: ${e.toString()}"),
      );
    }
  }

  getProductById(int id) async {
    try {
      emit(ProductState.loading());
      Product product = await PhoneAPI.getProductById(id);
      emit(ProductState.successOnly(product));
    } catch (e) {
      emit(
        ProductState.error("Error loading product detail: $e"),
      );
    }
  }

  setAllProductState() {
    emit(ProductState.successAll(allProducts));
  }

  handleAddProductInCart(Product product) async {
    return await MySharedRef.addProductInCart(product);
  }
}

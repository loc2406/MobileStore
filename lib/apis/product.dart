import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_store/apis/base.dart';

import '../models/product.dart';

class PhoneAPI {
  static const String allProducts = '${BaseAPI.api}/products';

  static Future<List<Product>> getAllProducts() async {
    final baseUrl = Uri.parse(allProducts);
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      return convertFromJsonList(response.body);
    }
    throw Exception('Failed to get all products: ${response.statusCode}');
  }

  static List<Product> convertFromJsonList(String responseBody) {
    final Map<String, dynamic> listObject = json.decode(responseBody);
    final List<dynamic> jsonResponse = listObject['content'];
    return jsonResponse.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product> getProductById(int id) async {
    final baseUrl = Uri.parse('$allProducts/$id');
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      final Map<String, dynamic> phoneJson = json.decode(response.body);
      return Product.fromJson(phoneJson);
    }
    throw Exception('Failed to get product by id: ${response.statusCode}');
  }
}

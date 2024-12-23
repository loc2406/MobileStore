class CartProduct{
  final int productId;
  final String productName;
  int quantity;
  final int unitPrice;

  CartProduct({required this.productId, required this.productName, required this.quantity, required this.unitPrice});

  factory CartProduct.fromMap(Map<String, dynamic> map) {
    return CartProduct(
      productId: int.parse(map['productId'].toString()),
      productName: map['productName'].toString(),
      quantity: int.parse(map['quantity'].toString()),
      unitPrice: int.parse(map['unitPrice'].toString()));
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}
class Product {
  final int id;
  final String name;
  final String image;
  final int price;
  final String description;
  final String manufacturer;
  final int quantity;
  final String category;
  final String condition;

  Product(
      {required this.id,
      required this.name,
      required this.image,
      required this.price,
      required this.description,
      required this.manufacturer,
      required this.quantity,
      required this.category,
      required this.condition,});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        image: json['image'],
        price: json['price'],
        description: json['description'],
        manufacturer: json['manufacturer'],
        quantity: json['quantity'],
        category: json['category'],
        condition: json['condition']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'manufacturer': manufacturer,
      'quantity': quantity,
      'price': price,
      'image': image,
      'category': category,
      'condition': condition,
    };
  }
}

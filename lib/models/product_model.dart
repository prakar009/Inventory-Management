class Product {
  final String id;
  final String name;
  final double price;
  final int stockCount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stockCount,
  });

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      stockCount: map['stockCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stockCount': stockCount,
    };
  }
}
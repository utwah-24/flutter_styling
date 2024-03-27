// ignore_for_file: non_constant_identifier_names

class ProductData {
  final String product_name;
  final String product_amount;
  final double product_price;

  ProductData(
      {required this.product_name,
      required this.product_amount,
      required this.product_price});

  Map<String, dynamic> toMap() {
    return {
      'product_name': product_name,
      'product_amount': product_amount,
      'product_price': product_price,
    };
  }

  factory ProductData.fromMap(Map<String, dynamic> map) {
    return ProductData(
      product_name: map['product_name'] ?? "",
      product_amount: map['product_amount'] ?? "",
      product_price: map['product_price'] ?? "",
    );
  }
}

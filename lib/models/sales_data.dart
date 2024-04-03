// ignore_for_file: non_constant_identifier_names

class SalesData {
  final int? productID;
  final String title;
  final double price;
  final String chosen_date;

  SalesData({
     this.productID,
    required this.title,
    required this.price,
    required this.chosen_date,
  });

  Map<String, dynamic> toMap() {
    return {
      'Product_ID': productID,
      'Title': title,
      'Price': price,
      'Chosen_Date': chosen_date,
    };
  }

  factory SalesData.fromMap(Map<String, dynamic> map) {
    return SalesData(
      productID: map['Product_ID'] ?? 0,
      title: map['Title'] ?? "",
      price: map['Price'] ?? 0.0,
      chosen_date: map['Chosen_Date'] ?? "",
    );
  }
}

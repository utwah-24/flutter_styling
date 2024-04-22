// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';

class SalesData {
  final int productID;
  final String title;
  final double price;
  final String chosen_date;

  SalesData({
    required this.productID,
    required this.title,
    required this.price,
    required this.chosen_date,
  });

  get id => productID;

  get weekNumber => null;

  get salesAmount => price;

  Map<String, dynamic> toMap() {
    String dateString =
        DateFormat('yyyy-MM-dd').format(chosen_date as DateTime);

    return {
      'Product_ID': productID,
      'Title': title,
      'Price': price,
      'Chosen_Date': dateString,
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

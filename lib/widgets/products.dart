import 'package:flutter/material.dart';
import '../models/product_data.dart';
import '../database/products_data.dart';
import 'custom_apbar.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _is_Dark = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  List<DataRow> productRows = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Load existing products from the database
  }

  Future<void> con_pro_data() async {
    String product_name = _nameController.text;
    String product_amount = _amountController.text;
    double product_price = double.tryParse(_priceController.text) ?? 0;
    if (product_name.isEmpty && product_amount.isEmpty && product_price == 0) {
      return; // No data to insert, return from the function
    }

    try {
      await DatabaseHelper.insertProducts(ProductData(
        product_name: product_name,
        product_amount: product_amount,
        product_price: product_price,
      ));

      print("inserting data...");
      _fetchProducts(); // Fetch and display all data after inserting new data

      _nameController.clear();
      _amountController.clear();
      _priceController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to input data. Try again.'),
      ));
      print('Error inserting data into database: $e');
    }
  }

  Future<void> _fetchProducts() async {
    try {
      List<ProductData> products = await DatabaseHelper.getProducts();
      print("fetched products");
      print(products);
      setState(() {
        productRows = products.map((product) {
          return DataRow(cells: [
            DataCell(Text(product.product_name)),
            DataCell(Text(product.product_amount)),
            DataCell(Text(product.product_price.toString())),
          ]);
        }).toList();
      });
    } catch (e) {
      print('Error fetching products from database: $e');
    }
  }

  // Future<void> _fetchProducts() async {
  //   String product_name = _nameController.text;
  //   String product_amount = _amountController.text;
  //   double product_price = double.tryParse(_priceController.text) ?? 0;

  //   try {
  //     List<ProductData> products = await DatabaseHelper.getProducts(
  //         product_name, product_amount, product_price);
  //     print("fetched products");
  //     print(products);
  //     setState(() {
  //       productRows = products.map((product) {
  //         return DataRow(cells: [
  //           DataCell(Text(product.product_name)),
  //           DataCell(Text(product.product_amount)),
  //           DataCell(Text(product.product_price.toString())),
  //         ]);
  //       }).toList();
  //     });
  //   } catch (e) {
  //     print(product_name);
  //     print(product_amount);
  //     print(product_price);
  //     print('Error fetching products from database: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _is_Dark
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.purple,
              appBarTheme: AppBarTheme(),
            ),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Products',
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10.0, right: 5),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 26,
                ),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your product name',
                    prefixIcon: Icon(Icons.shopping_cart),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter your kilos ',
                    prefixIcon: Icon(Icons.fitness_center),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _priceController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter the price ',
                    prefixIcon: Icon(Icons.monetization_on),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Submit',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    con_pro_data();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: FittedBox(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Price')),
                        ],
                        rows: productRows,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';


class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _is_Dark = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<DataRow> productRows = [];

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
          appBar: AppBar(
            title: const Text("Products"),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(Icons.person),
              )
            ],
            titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 10.0, right: 5),
            // Remove constraints here
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 26,
                  ),
                  TextFormField(
                    controller: nameController,
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
                    controller: amountController,
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
                    controller: priceController,
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        productRows.add(
                          DataRow(cells: [
                            DataCell(Text(nameController.text)),
                            DataCell(Text(amountController.text)),
                            DataCell(Text(priceController.text)),
                          ]),
                        );
                      });
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

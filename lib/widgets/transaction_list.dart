// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_styling/database/daily_sales.dart';
import 'package:flutter_styling/models/sales_data.dart';
import 'package:flutter_styling/widgets/new_transaction.dart';
// import '../models/transaction.dart';

class TransactionsList extends StatefulWidget {
  //   final TextEditingController titleController;
  // final TextEditingController amountController;
  // final DateTime selectedDate;
  List<SalesData> salesData;
  TransactionsList({super.key, required this.salesData});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
 

@override
void initState() {
  super.initState();
  
  // Check if salesData is not empty
  if (widget.salesData.isNotEmpty) {
    // Get the values from the first element of the salesData list
    SalesData firstSalesData = widget.salesData.first;
    
    // Pass the values to _onNewTransactionAdded
    onNewTransactionAdded(SalesData(
      productID: firstSalesData.productID,
      title: firstSalesData.title,
      price: firstSalesData.price,
      chosen_date: firstSalesData.chosen_date,
    ));
  }
}



  void _deleteTransaction(SalesData salesData) async {
    if (await DatabaseHelper.deleteSales(salesData.productID ?? 0)) {
      setState(() {
        widget.salesData.remove(salesData);
      });
    }
  }

  void _presentDatepicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2016),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitData() {
    // Handle form submission here if needed
  }

onNewTransactionAdded(SalesData p1) async {
  // Fetch the updated list of sales data from the database
  List<SalesData> updatedSalesData = await DatabaseHelper.getSales();
  
  // Update the state with the new data
  setState(() {
    widget.salesData = updatedSalesData;
  });
}


  void _updateWeekTotals() {
    // Handle updating weekly totals here if needed
  }
void _editTransaction(SalesData transaction) {
  _titleController.text = transaction.title;
  _amountController.text = transaction.price.toString();
  _selectedDate = DateTime.parse(transaction.chosen_date);

  showModalBottomSheet(
    context: context,
    builder: (_) {
      return NewTransaction(
        titleController: _titleController,
        amountController: _amountController,
        selectedDate: _selectedDate,
        submitData: _submitData,
        updateWeekTotals: _updateWeekTotals,
        onNewTransactionAdded: onNewTransactionAdded,
        existingTransaction: transaction,
        openDatePicker: _presentDatepicker,
        salesData: widget.salesData,
      );
    },
  ).then((_) {
    // This code will be executed after the bottom sheet is dismissed
    SalesData? result;
    onNewTransactionAdded(result!);
  });
  
}


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Column(
        children: [
          widget.salesData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'No Transactions added yet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: constraint.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/waiting.png',
                          fit: BoxFit.cover,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  children: widget.salesData
                      .map(
                        (transaction) => Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: FittedBox(
                                  child: Text('${transaction.price}/='),
                                ),
                              ),
                            ),
                            title: Text(
                              transaction.title,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(transaction.chosen_date),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      _editTransaction(transaction),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.purple,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _deleteTransaction(transaction),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      );
    });
  }
}

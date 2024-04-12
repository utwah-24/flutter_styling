// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_null_comparison, duplicate_ignore, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/daily_sales.dart';
import '../database/database_create.dart';
import '../models/sales_data.dart';
// import '../database/daily_sales.dart';
// import '../models/sales_data.dart';

// ignore: must_be_immutable
class NewTransaction extends StatefulWidget {
  final Function() submitData;
  final Function(SalesData) onNewTransactionAdded;
  final Function() openDatePicker;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final List<SalesData> salesData;
  late DateTime selectedDate;
  final Function updateWeekTotals;
  final SalesData? existingTransaction; // Add this callback

  NewTransaction({
    required this.amountController,
    required this.openDatePicker,
    required this.submitData,
    required this.titleController,
    required this.selectedDate,
    required this.onNewTransactionAdded,
    required this.updateWeekTotals,
    this.existingTransaction,
    required this.salesData, // Initialize the callback
  });

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  @override
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      widget.titleController.text = widget.existingTransaction!.title;
      widget.amountController.text =
          widget.existingTransaction!.price.toString();
      // You may need to format the date according to your requirements
      widget.selectedDate =
          DateTime.parse(widget.existingTransaction!.chosen_date);
    }
  }

  void _handleSubmitted() async {
    if (widget.existingTransaction != null) {
      String datestring = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
      // Perform update operation
      SalesData updatedTransaction = SalesData(
        productID: widget.existingTransaction!.productID,
        title: widget.titleController.text,
        price: double.parse(widget.amountController.text),
        chosen_date: datestring,
      );
      final db = await DatabaseHelperCreate.db();
      await SQLHelper_dailySales.updateSalesData(
        db,
        updatedTransaction.productID,
        updatedTransaction.title,
        updatedTransaction.price,
        updatedTransaction.chosen_date,
      );
      Navigator.pop(context);

      // Update local UI immediately
      // setState(() {
      //   // Update existing transaction in widget.salesData
      //   int index = widget.salesData.indexWhere((element) =>
      //       element.productID == widget.existingTransaction!.productID);
      //   if (index != -1) { 
      //     widget.salesData[index] = updatedTransaction;
      //   }
      // });
    } else {
      // Perform insert operation
      widget.submitData();
      SalesData newTransaction = SalesData(
        title: widget.titleController.text,
        price: double.parse(widget.amountController.text),
        chosen_date: widget.selectedDate.toString(),
        productID: widget.existingTransaction?.productID ?? 0,
      );
      widget.onNewTransactionAdded(newTransaction);
      // Update weekly totals after adding a new transaction
      widget.updateWeekTotals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: widget.titleController,
                onSubmitted: (_) => _handleSubmitted(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: widget.amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _handleSubmitted(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(widget.selectedDate == null
                          ? 'No Date Chosen'
                          : 'Picked Date:${DateFormat.yMd().format(widget.selectedDate)}'),
                    ),
                    TextButton(
                      onPressed: widget.openDatePicker,
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        'Choose date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: _handleSubmitted,
                child: Text(widget.existingTransaction != null
                    ? 'Update'
                    : 'Add transaction'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

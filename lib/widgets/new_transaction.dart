// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../models/sales_data.dart';

class NewTransaction extends StatefulWidget {
  final Function()? submitData;
  final Function(SalesData)? onNewTransactionAdded;
  final Function() openDatePicker;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final List<SalesData?> salesData;
  late DateTime selectedDate;
  late final Function(SalesData)? editData;
  late SalesData? existingTransaction;

  NewTransaction({
    required this.amountController,
    required this.openDatePicker,
    this.submitData,
    required this.titleController,
    required this.selectedDate,
    this.onNewTransactionAdded,
    this.existingTransaction,
    required this.salesData,
    this.editData,
  }) {
    existingTransaction ??= null;
  }

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  @override
  void initState() {
    super.initState();
  }

  void _handleSubmitted() async {
    if (widget.existingTransaction != null) {
      print('heyy.....');
      widget.editData!(widget.existingTransaction!);
      Navigator.of(context).pop();
    } else {
      // Perform insert operation
      if (widget.submitData != null) {
        widget.submitData!();
      }
      SalesData newTransaction = SalesData(
        title: widget.titleController.text,
        price: double.parse(widget.amountController.text),
        chosen_date: widget.selectedDate.toString(),
        productID: widget.existingTransaction?.productID ?? 0,
      );
      if (widget.onNewTransactionAdded != null) {
        widget.onNewTransactionAdded!(newTransaction);
      }
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
                onPressed: () {
  if (widget.existingTransaction != null && widget.editData != null) {
    widget.editData!(widget.existingTransaction!);
    Navigator.of(context).pop();
  }
},

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

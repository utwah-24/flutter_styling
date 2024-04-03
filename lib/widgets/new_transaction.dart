// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_null_comparison, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import '../database/daily_sales.dart';
// import '../models/sales_data.dart';

class NewTransaction extends StatefulWidget {
  final Function() submitData;
  final Function() openDatePicker;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final DateTime selectedDate;

  NewTransaction({
    required this.amountController,
    required this.openDatePicker,
    required this.submitData,
    required this.titleController,
    required this.selectedDate,
  });

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  void _handleSubmitted(String value) {
    widget.submitData(); // Call submitData function
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
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: widget.titleController,
                    onSubmitted: _handleSubmitted,

                    // onChanged: (val) {
                    //   titleInput = val;
                    // },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: widget.amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: _handleSubmitted,

                    // onChanged: (val) {
                    //   amountInput = val;
                    // },
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: [
                        // ignore: unnecessary_null_comparison
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
                        foregroundColor: Colors.white),
                    onPressed: () {
                      widget.submitData();
                    },
                    child: Text('Add transaction'),
                  )
                ])),
      ),
    );
  }
}

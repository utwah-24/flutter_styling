// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_null_comparison, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.timestamp();

  void _submitData() {
    final eneterdTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (eneterdTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(eneterdTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2016),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
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
                    controller: _titleController,
                    onSubmitted: (_) => _submitData,
                    // onChanged: (val) {
                    //   titleInput = val;
                    // },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _submitData,
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
                          child: Text(_selectedDate == null
                              ? 'No Date Chosen'
                              : 'Picked Date:${DateFormat.yMd().format(_selectedDate)}'),
                        ),
                        TextButton(
                          onPressed: _presentDatepicker,
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
                    onPressed: _submitData,
                    child: Text('Add transaction'),
                  )
                ])),
      ),
    );
  }
}
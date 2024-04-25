// ignore_for_file: avoid_print, must_be_immutable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_styling/database/daily_sales.dart';
import 'package:flutter_styling/models/sales_data.dart';

import 'package:intl/intl.dart';

import '../database/database_create.dart';
// import '../models/transaction.dart';

class TransactionsList extends StatefulWidget {
  late SalesData? existingTransaction;
  // final Function(SalesData)
  //   final TextEditingController titleController;
  // final TextEditingController amountController;
  // final DateTime selectedDate;
  List<SalesData> salesData = [];
  final Function(SalesData?)? editData;
  TransactionsList({super.key, required this.salesData, this.editData});

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
    // _fetchupdates();
    // onNewTransactionAdded();
  }

  void _deleteTransaction(SalesData salesData) async {
    // Show a confirmation dialog before deleting the transaction
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this transaction?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // If the user confirms deletion, proceed with deletion
                Navigator.of(context).pop(true);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                // If the user cancels, simply close the dialog
                Navigator.of(context).pop(false);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    ).then((confirmDelete) async {
      // Proceed with deletion if the user confirmed
      if (confirmDelete) {
        if (await DatabaseHelper.deleteSales(salesData.productID )) {
          setState(() {
            widget.salesData.remove(salesData);
          });
        }
      }
    });
  }

  // void selectTransaction(SalesData? transaction) {
  //   // Implement the logic to handle the selection of the transaction to edit
  //   // For example, you can set the selected transaction to be edited
  //   if (transaction != null) {
  //     setState(() {
  //       _titleController.text = transaction.title;
  //       _amountController.text = transaction.price.toString();
  //       _selectedDate = DateTime.parse(transaction.chosen_date);
  //     });
  //   }
  // }

  // void _presentDatepicker() {
  //   showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(2016),
  //     lastDate: DateTime.now(),
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     setState(() {
  //       _selectedDate = pickedDate;
  //     });
  //   });
  // }

  Future<void> _handleEdit(SalesData? data) async {
    widget.existingTransaction = data;
    print('editing.......$data');
    if (widget.existingTransaction != null) {
      // Perform update operation
      

      SalesData updatedTransaction = SalesData(
        productID: data!.productID,
        title: data.title,
        price: data.price,
        chosen_date: data.chosen_date,
      );

      print('updating bro.....');
      final db = await DatabaseHelperCreate.db();
      await SQLHelper_dailySales.updateSalesData(
        db,
        updatedTransaction.productID,
        updatedTransaction.title,
        updatedTransaction.price,
        updatedTransaction.chosen_date,
      );
      print('going to Update local UI immediately ');
      // Update local UI immediately
      widget.editData!(updatedTransaction);

      _titleController.clear();
      _amountController.clear();
    } else {
      print('cant do it bro..');
    }
  }

  void _editTransaction(SalesData transaction) {
    _titleController.text = transaction.title;
    _amountController.text = transaction.price.toString();
    _selectedDate = DateTime.parse(transaction.chosen_date);

    showModalBottomSheet(
        context: context,
        builder: (_) {
          print('i am going to the NewTransaction widget');
          return EditTransactionModal(
            transaction: transaction,
            editData: _handleEdit,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: Column(
          children: [
            widget.salesData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'No Transactions added yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
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
                            margin: const EdgeInsets.symmetric(
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
                                style: const TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(DateFormat('yyyy-MMM-dd').format(
                                  DateTime.parse(transaction.chosen_date))),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _editTransaction(transaction),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _deleteTransaction(transaction),
                                    icon: const Icon(
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
        ),
      );
    });
  }
}

class EditTransactionModal extends StatefulWidget {
  final Function(SalesData)? editData;
  final SalesData transaction;

  const EditTransactionModal({
    super.key,
    required this.transaction,
    required this.editData,
  });

  @override
  _EditTransactionModalState createState() => _EditTransactionModalState();
}

class _EditTransactionModalState extends State<EditTransactionModal> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;

  @override
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController =
        TextEditingController(text: widget.transaction.price.toString());
    _selectedDate = DateTime.parse(widget.transaction.chosen_date);
  }

  void _handleSubmitted() async {
    // Perform edit operation
    SalesData updatedTransaction = SalesData(
      productID: widget.transaction.productID,
      title: _titleController.text,
      price: double.parse(_amountController.text),
      chosen_date: _selectedDate.toString(),
    );
    print(updatedTransaction.title);
    print(updatedTransaction.productID);
    widget.editData!(updatedTransaction);
    Navigator.of(context).pop();
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
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _handleSubmitted(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _handleSubmitted(),
              ),
              SizedBox(
                  height: 70,
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        'Picked Date: ${DateFormat('yyyy-MMM-dd').format(_selectedDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
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
                      },
                      child: const Text(
                        'Choose date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ])),
              ElevatedButton(
                onPressed: _handleSubmitted,
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

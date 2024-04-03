// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_styling/database/daily_sales.dart';
import 'package:flutter_styling/models/sales_data.dart';
import 'package:flutter_styling/models/transaction.dart';
import 'package:flutter_styling/widgets/new_transaction.dart';
import './transaction_list.dart';
import 'chart.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // late String titleInput;
  // final List<Transaction> _userTransactions = [
  //   // Transaction(id: 'a1', title: 'Vans', amount: 30000, date: DateTime.now()),
  //   // Transaction(
  //   //     id: 'a2', title: 'Jordans', amount: 45000, date: DateTime.now()),
  //   // Transaction(
  //   //     id: 'a2', title: 'chocolate', amount: 3000, date: DateTime.now())
  // ];
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Function<void> submit = _submitData();
  List<SalesData> _salesData = [];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getSalesData();
  }

  void didChangelifeAppLifeCycleState(AppLifecycleState state) {
    // print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

// ignore: unused_element
List<SalesData> get _recentTransactions {
  return _salesData.where((tx) {
    
    DateTime chosenDate = DateTime.parse(tx.chosen_date);
    return chosenDate.isAfter(DateTime.now().subtract(const Duration(days: 7)));
  }).toList();
}


  // void _addNewTransaction(
  //     String txTitle, double txAmount, DateTime ChosenDate) {
  //   final newTx = Transaction(
  //       title: txTitle,
  //       amount: txAmount,
  //       date: ChosenDate,
  //       id: DateTime.now().toString());

  //   setState(() {
  //     chosen_date.add(newTx);
  //   });
  // }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: Colors.grey,
        context: ctx,
        builder: (_) {
          return NewTransaction(
            openDatePicker: _presentDatepicker,
            submitData: _submitData,
            titleController: _titleController,
            amountController: _amountController,
            selectedDate: _selectedDate,
          );
        });
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

  // void _deleteTransaction(String id) {
  //   setState(() {
  //     _salesData.removeWhere((tx) {
  //       return tx.id == id;
  //     });
  //   });
  // }

  Future<void> _submitData() async {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    try {
      // Convert DateTime to string representation
      String dateString = _selectedDate.toString();

      // Insert transaction data into the database
      await DatabaseHelper.insertSales(SalesData(
        productID: 0,
        title: enteredTitle,
        price: enteredAmount,
        chosen_date: dateString, // Pass string representation
      ));

      // Clear the text fields after adding the transaction
      _titleController.clear();
      _amountController.clear();

      _getSalesData();

      // Close the bottom sheet
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to input data. Try again.'),
      ));
      print(_selectedDate);

      print('Error inserting data into database: $e');
    }
  }

  Future<void> _getSalesData() async {
    _salesData = await DatabaseHelper.getSales();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appbar = AppBar(
      title: Text('Sales'),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(Icons.person),
        )
        // IconButton(
        //   icon: Icon(Icons.add),
        //   onPressed: () => _startAddNewTransaction(context),
        // )
      ],
      centerTitle: true,
    );

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionsList(
          salesData: _salesData,
        ));
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
  if (isLandscape)
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Show chart'),
        Switch(
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },
        )
      ],
    ),
  if (!isLandscape)
    Container(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        child: Chart(_recentTransactions)), // Correct _recentTrasactions to _recentTransactions
  if (!isLandscape) txListWidget,
  if (isLandscape)
    _showChart
        ? Container(
            height: (MediaQuery.of(context).size.height -
                    appbar.preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                0.7,
            child: Chart(_recentTransactions)) // Correct _recentTrasactions to _recentTransactions
        : txListWidget
], 
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}

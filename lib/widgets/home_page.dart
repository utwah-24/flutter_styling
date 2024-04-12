// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_styling/database/daily_sales.dart';
import 'package:flutter_styling/models/sales_data.dart';
// import 'package:flutter_styling/models/transaction.dart';
import 'package:flutter_styling/widgets/new_transaction.dart';
import 'package:flutter_styling/widgets/weeks.dart';
import './transaction_list.dart';
import 'chart.dart';
import 'package:intl/intl.dart';


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<SalesData> _salesData = [];
  bool _showChart = false;


  double week1Total = 0;
  double week2Total = 0;
  double week3Total = 0;
  double week4Total = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _getSalesData();
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<SalesData> get _recentTransactions {
    return _salesData.where((tx) {
      DateTime chosenDate = DateTime.parse(tx.chosen_date.toString());
      return chosenDate
          .isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(SalesData newTransaction) {
    setState(() {
      _salesData.add(newTransaction);
    });
    Navigator.of(context).pop();
    _updateWeekTotals(); // Close the bottom sheet after adding the transaction
  }

  void _updateWeekTotals() {
    // Clear previous week totals
    week1Total = 0;
    week2Total = 0;
    week3Total = 0;
    week4Total = 0;

    // Calculate weekly totals
    DateTime now = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month);
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1);

    _salesData.forEach((transaction) {
      DateTime transactionDate =
          DateTime.parse(transaction.chosen_date);
      if (transactionDate.isAfter(firstDayOfCurrentMonth) &&
          transactionDate.isBefore(firstDayOfNextMonth)) {
        if (transactionDate.day <= 7) {
          week1Total += transaction.price;
        } else if (transactionDate.day <= 14) {
          week2Total += transaction.price;
        } else if (transactionDate.day <= 21) {
          week3Total += transaction.price;
        } else {
          week4Total += transaction.price;
        }
      }
    });

    // Update the UI
    setState(() {});
  }

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
          onNewTransactionAdded: _addNewTransaction,
          updateWeekTotals: _updateWeekTotals, salesData: _salesData,
        );
      },
    );
  }

  void _presentDatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  void _deleteTransaction(String id) {
    setState(() {
      _salesData.removeWhere((tx) {
        return tx.id == id; // Compare tx.id with the id parameter
      });
    });
  }

  Future<void> _submitData() async {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    try {
      String dateString = DateFormat('yyyy-MM-dd').format(
          _selectedDate); // Assuming _selectedDate is already a DateTime object
      

      await DatabaseHelper.insertSales(SalesData(
        productID: 0,
        title: enteredTitle,
        price: enteredAmount,
        chosen_date: dateString,
        
      ));

      _titleController.clear();
      _amountController.clear();
      _getSalesData();

      
     
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to input data. Try again.'),
      ));
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
      automaticallyImplyLeading: false,
      title: Text('Sales'),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(Icons.person),
        )
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
      ),
    );

    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
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
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appbar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget,
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



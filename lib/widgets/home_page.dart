// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_styling/database/daily_sales.dart';
import 'package:flutter_styling/models/sales_data.dart';
// import 'package:flutter_styling/models/transaction.dart';
import 'package:flutter_styling/widgets/new_transaction.dart';


import './transaction_list.dart';
import 'chart.dart';
import 'package:intl/intl.dart';

import 'custom_appbar.dart';

class MyHomePage extends StatefulWidget {
  final String userEmail;

  const MyHomePage({
    Key? key,
    required this.userEmail, // Add userEmail parameter
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<SalesData> _salesData = [];
  bool _showChart = false;
  SalesData? existingTransaction;

  SalesData? get data => existingTransaction;
  // _MyHomePageState() {
  //   existingTransaction ??= null;
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _getSalesData();
    // _updated();
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

  void _addNewTransaction(SalesData newTransaction) async {
    print('adding.....');

    Navigator.of(context).pop();
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
          salesData: _salesData,
          editData: _editing,
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

  Future<void> _submitData() async {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    print('submit data...');
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to input data. Try again.'),
      ));
      print('Error inserting data into database: $e');
    }
  }

  Future<void> _getSalesData() async {
    _salesData = await DatabaseHelper.getSales();
    setState(() {});
  }

  void _editing(SalesData? data) {
    print('UI updating...');
    if (data != null) {
      setState(() {
        // Find the index of the existing transaction in _salesData
        print(data.id);
        int index = _salesData.indexWhere((tx) => tx.id == data.id);
        print("DATA ID: ${data.id}");
        print("INDEX: $index");
        if (index != -1) {
          // If the transaction exists, replace it with the updated one
          _salesData[index] = data;
        } else {
          // If the transaction doesn't exist, add it to _salesData
          _salesData.add(data);
        }
        // Sort the transactions by date after the update
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appbar = MyAppBar(
      userEmail: widget.userEmail,
      title: 'Sales',
    ); // Use userEmail parameter
    ;
    print(widget.userEmail);

    final txListWidget = SingleChildScrollView(
      child: SizedBox(
        height: (MediaQuery.of(context).size.height -
                appbar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionsList(salesData: _salesData, editData: _editing),
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
                  const Text('Show chart'),
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
              SizedBox(
                height: (MediaQuery.of(context).size.height -
                        appbar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? SizedBox(
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
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}

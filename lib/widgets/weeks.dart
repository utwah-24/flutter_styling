import 'package:flutter/material.dart';
import 'package:flutter_styling/models/sales_data.dart';
import 'package:intl/intl.dart';
import '../database/daily_sales.dart';
import 'mon_selector.dart';

class Weeks extends StatefulWidget {
  final void Function(List<double>) onWeekTotalsCalculated;
  final String selectedMonth; // Add selectedMonth parameter

  Weeks({
    Key? key,
    required this.onWeekTotalsCalculated,
    required this.selectedMonth,
  }) : super(key: key);

  @override
  _WeeksState createState() => _WeeksState();
}

class _WeeksState extends State<Weeks> {
  late List<double> weekTotals;
  List<List<SalesData>> weeklyTransactions = List.filled(4, []);

  @override
  void initState() {
    super.initState();
    weekTotals = List.filled(4, 0);
    fetchWeeklyTransactions();
  }

  void fetchWeeklyTransactions() async {
    try {
      List<SalesData> allSales = await DatabaseHelper.getSales();
      DateTime now = DateTime.now();
      List<double> newWeekTotals = List.filled(4, 0); // Initialize with zeros

      for (int i = 0; i < weeklyTransactions.length; i++) {
        List<SalesData> transactions = [];
        print('i am filtering');
        for (var transaction in allSales) {
          DateTime transactionDate = DateTime.parse(transaction.chosen_date);
          int weekNumber = _calculateWeekNumber(transactionDate, now);
          String transactionMonth = DateFormat('MMM').format(transactionDate);
          if (weekNumber == i + 1 && transactionMonth == widget.selectedMonth) {
            transactions.add(transaction);
            newWeekTotals[i] += transaction.price;
          }
        }

        weeklyTransactions[i] = transactions;
      }

      widget.onWeekTotalsCalculated(newWeekTotals);
      setState(() {
        weekTotals = newWeekTotals; // Update weekTotals with the new values
      });
    } catch (e) {
      print("Error fetching weekly transactions: $e");
    }
  }

  int _calculateWeekNumber(DateTime transactionDate, DateTime currentDate) {
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    int daysDifference = transactionDate.difference(firstDayOfMonth).inDays;
    int weekNumber = ((daysDifference + firstDayOfMonth.weekday) / 7).ceil();
    return weekNumber;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < weeklyTransactions.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text('Week ${i + 1}'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Price:'),
                          SizedBox(width: 10),
                          Text("${weekTotals[i]}"),
                        ],
                      ),
                      SizedBox(height: 3),
                      Divider(color: Colors.grey),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

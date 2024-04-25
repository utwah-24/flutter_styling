import 'package:flutter/material.dart';
import 'package:flutter_styling/models/sales_data.dart';
import 'package:flutter_styling/widgets/custom_appbar.dart';

import '../database/daily_sales.dart';
import 'package:intl/intl.dart';

class Report extends StatefulWidget {
  const Report({
    super.key,
  });

  @override
  State<Report> createState() => _Reportpage2State();
}

class _Reportpage2State extends State<Report> {
  List<List<SalesData>> weeklyTransactions = List.filled(4, []);
  List<SalesData> salesData = [];
  late List<double> weekTotals;
  bool _isDark = false;
  late String _currentMonth; // Current month
  late double week1Total; // Initialize with default value
  late double week2Total; // Initialize with default value
  late double week3Total; // Initialize with default value
  late double week4Total;

  @override
  void initState() {
    super.initState();
    // Initialize _currentMonth with the current month
    _currentMonth = DateFormat('MMM').format(DateTime.now());
    weekTotals = List.filled(4, 0);
    fetchWeeklyTransactions();
    week1Total = 0;
    week2Total = 0;
    week3Total = 0;
    week4Total = 0;
  }

  void fetchWeeklyTransactions() async {
    try {
      List<SalesData> allSales = await DatabaseHelper.getSales();
      DateTime now = DateTime.now();
      List<double> newWeekTotals = List.filled(4, 0); // Initialize with zeros
      List<List<SalesData>> newWeeklyTransactions = List.filled(4, []);

      for (int i = 0; i < weeklyTransactions.length; i++) {
        List<SalesData> transactions = [];
        print('i am filtering');
        for (var transaction in allSales) {
          DateTime transactionDate = DateTime.parse(transaction.chosen_date);
          int weekNumber = _calculateWeekNumber(transactionDate, now);
          String transactionMonth = DateFormat('MMM').format(transactionDate);
          if (weekNumber == i + 1 && transactionMonth == _currentMonth) {
            transactions.add(transaction);
            newWeekTotals[i] += transaction.price;
          }
        }

        newWeeklyTransactions[i] = transactions;
      }

      updateWeekTotals(newWeekTotals);
      setState(() {
        weeklyTransactions = newWeeklyTransactions;
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

  String getNextMonth(String currentMonth) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    int currentIndex = months.indexOf(currentMonth);
    int nextIndex = (currentIndex + 1) % months.length;
    return months[nextIndex];
  }

  String getPreviousMonth(String currentMonth) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    int currentIndex = months.indexOf(currentMonth);
    int previousIndex = (currentIndex - 1 + months.length) % months.length;
    return months[previousIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.purple,
              appBarTheme: const AppBarTheme(),
            ),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Report',
        ),
        // appBar: MyAppBar(
        //   title: 'Report',
        //   // userEmail: widget.userEmail,

        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    fetchWeeklyTransactions();
                    String previousMonth = getPreviousMonth(_currentMonth);

                    setState(() {
                      _currentMonth = previousMonth;
                    });
                  },
                ),
                Text(
                  _currentMonth,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    fetchWeeklyTransactions();
                    String nextMonth = getNextMonth(_currentMonth);

                    setState(() {
                      _currentMonth = nextMonth;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 290,
              width: 500,
              child: Container(
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
            ),
            const SizedBox(height: 50),
            MonTotal(
              week1Total: week1Total,
              week2Total: week2Total,
              week3Total: week3Total,
              week4Total: week4Total,
            ),
          ],
        ),
      ),
    );
  }

  void updateWeekTotals(List<double> totals) {
    print('this is week3 total ${totals[2]}');
    setState(() {
      week1Total = totals[0];
      week2Total = totals[1];
      week3Total = totals[2];
      week4Total = totals[3];
    });
  }
}

class MonTotal extends StatelessWidget {
  final double week1Total;
  final double week2Total;
  final double week3Total;
  final double week4Total;

  const MonTotal({
    required this.week1Total,
    required this.week2Total,
    required this.week3Total,
    required this.week4Total,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate monthly total by summing up the weekly totals
    final monthlyTotal = week1Total + week2Total + week3Total + week4Total;
    print('this is month total$monthlyTotal');

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Monthly Total',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$monthlyTotal',
            style: const TextStyle(fontSize: 24),
          )
        ]));
  }
}

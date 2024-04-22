import 'package:flutter/material.dart';
import 'package:flutter_styling/models/sales_data.dart';
import 'package:flutter_styling/widgets/custom_apbar.dart';
import 'mon_selector.dart';
import './weeks.dart';
import 'package:intl/intl.dart';

class Report extends StatefulWidget {
  const Report({
    super.key,
  });

  @override
  State<Report> createState() => _Reportpage2State();
}

class _Reportpage2State extends State<Report> {
  List<SalesData> salesData = [];
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

    week1Total = 0;
    week2Total = 0;
    week3Total = 0;
    week4Total = 0;
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
        appBar: AppBar(title: const Text('Report')),
        // appBar: MyAppBar(
        //   title: 'Report',
        //   // userEmail: widget.userEmail,

        body: Column(
          children: [
            MonthSelector(
              currentMonth: _currentMonth,
              onChanged: (newMonth) {
                setState(() {
                  _currentMonth = newMonth;
                });
              },
            ),
            const SizedBox(height: 20),
            Container(
              height: 290,
              width: 500,
              child: Weeks(
                onWeekTotalsCalculated: updateWeekTotals,
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

  @override
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


// void main() {
//   runApp(MaterialApp(
//     home: Report(),
//   ));
// }

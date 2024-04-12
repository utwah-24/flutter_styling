import 'package:flutter/material.dart';
import 'package:flutter_styling/models/sales_data.dart';
import 'mon_selector.dart';
import './weeks.dart';
import 'package:intl/intl.dart';

class Report extends StatefulWidget {
  Report({
    Key? key,
  }) : super(key: key);

  @override
  State<Report> createState() => _Reportpage2State();
}

class _Reportpage2State extends State<Report> {
  List<SalesData> salesData = [];
  bool _isDark = false;
  late String _currentMonth; // Current month
  double week1Total = 0.0; // Initialize with default value
  double week2Total = 0.0; // Initialize with default value
  double week3Total = 0.0; // Initialize with default value
  double week4Total = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize _currentMonth with the current month
    _currentMonth = DateFormat('MMM').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.purple,
              appBarTheme: AppBarTheme(),
            ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Report"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.person),
            )
          ],
          titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
        ),
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
                transactionData: salesData,
              ),
            ),
            SizedBox(height: 50),
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
    week1Total = totals[0];
    week2Total = totals[1];
    week3Total = totals[2];
    week4Total = totals[3];
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
    final monthlyTotal = week1Total + week2Total + week3Total + week4Total;

    return Container(
      width: 206,
      height: 76.51,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              'Monthly Total: $monthlyTotal',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          Positioned(
            left: 32,
            top: 47.61,
            child: Container(
              width: 144.05,
              height: 28.91,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(side: BorderSide(width: 1)),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Report(),
//   ));
// }

import 'package:flutter/material.dart';
import 'package:flutter_styling/models/sales_data.dart';
import '../database/daily_sales.dart';

class Weeks extends StatefulWidget {
  final List<SalesData> transactionData;
  final void Function(List<double>) onWeekTotalsCalculated;

  Weeks({
    Key? key,
    required this.transactionData,
    required this.onWeekTotalsCalculated,
  }) : super(key: key);

  @override
  _WeeksState createState() => _WeeksState();
}

class _WeeksState extends State<Weeks> {
  List<double> weekTotals = List.filled(4, 0);

  @override
  void initState() {
    super.initState();
    calculateTotals();
  }

  void calculateTotals() async {
    List<SalesData> weeklySales = await DatabaseHelper.getWeeklySales();
    if (weeklySales.isNotEmpty) {
      DateTime now = DateTime.now();
      // Calculate totals for each week separately
      for (int i = 0; i < weekTotals.length; i++) {
        double total = 0;
        for (var transaction in weeklySales) {
          DateTime transactionDate = DateTime.parse(transaction.chosen_date);
          int weekNumber = _calculateWeekNumber(transactionDate, now);
          if (weekNumber == i + 1) {
            total += transaction.price;
          }
        }
        // Update the weekly totals list
        setState(() {
          weekTotals[i] = total;
        });
      }
      // Call the callback function with the weekly totals
      widget.onWeekTotalsCalculated(weekTotals);
    } else {
      print("No weekly sales data available.");
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
                for (int i = 0; i < weekTotals.length; i++)
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
                          Container(
                            height: 15,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                            ),
                            child: Text(" ${weekTotals[i]}"),
                          ),
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

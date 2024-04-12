// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/sales_data.dart';
import './chart_bar.dart';
// import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<SalesData> recentTransactions;
  const Chart(this.recentTransactions, {super.key});
  List<Map<String, Object>> get groupedTransactionsValues {
  return List.generate(7, (index) {
    final weekDay = DateTime.now().subtract(
      Duration(days: index),
    );
    var totalSum = 0.0;
    for (var i = 0; i < recentTransactions.length; i++) {
      DateTime transactionDate =
          DateTime.parse(recentTransactions[i].chosen_date.toString());
      if (transactionDate.day == weekDay.day &&
          transactionDate.month == weekDay.month &&
          transactionDate.year == weekDay.year) {
        totalSum += recentTransactions[i].price;
      }
    }
    return {
      'day': DateFormat.E().format(weekDay).substring(0, 1),
      'price': totalSum
    };
  }).reversed.toList();
}

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + (item['price'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: groupedTransactionsValues.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
                data['day'] as String,
                data['price'] as double,
                totalSpending == 0.0
                    ? 0.0
                    : (data['price'] as double) / totalSpending),
          );
        }).toList(),
      ),
    );
  }
}
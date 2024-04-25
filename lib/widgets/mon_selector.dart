import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final String currentMonth;
  final Function(String) onChanged;
  final Function()? getWeeklyTransactions;
  // Changed the type of getWeeklyTransactions to accept a String parameter

  const MonthSelector({
    Key? key,
    required this.currentMonth,
    required this.onChanged,
    this.getWeeklyTransactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            getWeeklyTransactions;
            String previousMonth = getPreviousMonth(currentMonth);
            onChanged(previousMonth);
          },
        ),
        Text(
          currentMonth,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            getWeeklyTransactions;
            String nextMonth = getNextMonth(currentMonth);
            onChanged(nextMonth);
          },
        ),
      ],
    );
  }
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

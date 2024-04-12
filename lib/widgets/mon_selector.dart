import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final String currentMonth;
  final Function(String) onChanged;

  const MonthSelector({
    Key? key,
    required this.currentMonth,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            onChanged(getPreviousMonth(
                currentMonth)); // Call onChanged with the previous month
          },
        ),
        Text(
          currentMonth,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            onChanged(getNextMonth(
                currentMonth)); // Call onChanged with the next month
          },
        ),
      ],
    );
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
    int nextIndex = (currentIndex + 1) %
        months.length; // Calculate the next index with wrap-around for December
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
    int previousIndex = (currentIndex - 1 + months.length) %
        months
            .length; // Calculate the previous index with wrap-around for January
    return months[previousIndex];
  }
}
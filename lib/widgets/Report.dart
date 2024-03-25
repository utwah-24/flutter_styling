// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import './MonSelector.dart';

import './weeks.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _Reportpage2State();
}

class _Reportpage2State extends State<Report> {
  bool _isDark = false;
  String _currentMonth = 'Jan'; // Initial value for current month

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark
          ? ThemeData.dark()
          : ThemeData(primarySwatch: Colors.purple, appBarTheme: AppBarTheme()),
      child: Scaffold(
          appBar: AppBar(
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
              const SizedBox(
                height: 20,
              ),
              Container(height: 290, width: 500, child: Weeks()),
              SizedBox(height: 50),
              MonTotal()
              // Add other widgets related to the report here
            ],
          ),
         ),
    );
  }
}

class MonTotal extends StatelessWidget {
  const MonTotal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 206,
      height: 76.51,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              'Monthly Total',
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

void main() {
  runApp(MaterialApp(
    home: Report(),
  ));
}

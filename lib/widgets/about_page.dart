// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_styling/custom_/custom_home.dart';
import 'package:flutter_styling/widgets/settings.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Positioned(
              left: 80.50,
              top: 39.66,
              child: Center(
                child: Text(
                  'About us 🛒',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF9C27B0),
                    fontSize: 48,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomHome(userEmail: '',)), // Replace SecondPage with the name of your destination page
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back),
                    Text('Back to Home'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "About Sale-Mate Welcome to Sale-Mate! We're here to simplify your sales recording process. With our intuitive interface, effortless sales logging, and customizable categories, tracking your sales has never been easier. Gain real-time insights into your performance and make informed decisions to drive success. Choose Sale-Mate for efficiency, organization, and accessibility. Sign up today and experience the difference!",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

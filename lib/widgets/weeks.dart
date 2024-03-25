// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Weeks extends StatefulWidget {
  const Weeks({super.key});

  @override
  State<Weeks> createState() => _WeeksState();
}

class _WeeksState extends State<Weeks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(20),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text('Week 1'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('price:'),
                        Container(
                          height: 15,
                          width: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Center(
                      child: Text('Week 2'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('price:'),
                        Container(
                          height: 15,
                          width: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Center(
                      child: Text('Week 3'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('price:'),
                        Container(
                          height: 15,
                          width: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Center(
                      child: Text('Week 4'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('price:'),
                        Container(
                          height: 15,
                          width: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ])),
        ),
      ),
    );
  }
}

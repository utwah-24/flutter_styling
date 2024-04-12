// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ChartBar extends StatefulWidget {
  final String label;
  final double spendingAmount;
  final double spendingPcofTotal;

  const ChartBar(this.label, this.spendingAmount, this.spendingPcofTotal);

  @override
  State<ChartBar> createState() => _ChartBarState();
}

class _ChartBarState extends State<ChartBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraint) {
        return Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 3),
                height: constraint.maxHeight * 0.15,
                child: FittedBox(
                    child: Text('${widget.spendingAmount.toStringAsFixed(0)}/='))),
            SizedBox(
              height: constraint.maxHeight * 0.05,
            ),
            Container(
              height: constraint.maxHeight * 0.55,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: const Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: widget.spendingPcofTotal,
                    child: Container(
                        decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraint.maxHeight * 0.05,
            ),
            Container(
              height: constraint.maxHeight * 0.15,
              child: FittedBox(child: Text(widget.label)),
            )
          ],
        );
      },
    );
  }
}
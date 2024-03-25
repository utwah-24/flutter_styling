// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionsList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: <Widget>[
                Text(
                  'No Transactions added yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraint.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                          child: Text('${transactions[index].amount}/=')),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: TextStyle(
                        fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: IconButton(
                    onPressed: () => deleteTx(transactions[index].id),
                    icon: Icon(Icons.delete),
                    color: Colors.purple,
                  ),
                ),
              );
            },
            itemCount: transactions.length);
  }
}
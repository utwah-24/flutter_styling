import 'package:flutter/material.dart';
import 'package:flutter_styling/database/daily_sales.dart';
import 'package:flutter_styling/models/sales_data.dart';
import '../models/transaction.dart';

class TransactionsList extends StatefulWidget {
  List<SalesData> salesData;
  TransactionsList({required this.salesData});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  @override
  void initState() {
    super.initState();
  }

  void _deleteTransaction(SalesData salesData) async {
    if (await DatabaseHelper.deleteSales(salesData.productID ?? 0)) {
      setState(() {
        widget.salesData.remove(salesData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Column(
        children: [
          widget.salesData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'No Transactions added yet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
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
                  ),
                )
              : Column(
                  children: widget.salesData
                      .map(
                        (transaction) => Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: FittedBox(
                                  child: Text('${transaction.price}/='),
                                ),
                              ),
                            ),
                            title: Text(
                              transaction.title,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(transaction.chosen_date),
                            trailing: IconButton(
                              onPressed: () => _deleteTransaction(transaction),
                              icon: Icon(Icons.delete),
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      );
    });
  }
}

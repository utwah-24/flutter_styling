// ignore_for_file: unused_import

import 'package:flutter_styling/models/sales_data.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'database_create.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../widgets/transaction_list.dart';

class SQLHelper_dailySales {
  static Future<void> createSalesTables(Database database) async {
    await database.execute("""
      CREATE TABLE Sales(
        Product_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Title CHAR(20) NOT NULL,
        Price REAL NOT NULL,
        Chosen_Date TEXT NOT NULL
      )""");
  }

  static Future<void> insertSalesData(
      Database database, String title, double price, String chosen_date) async {
    await database.transaction((txn) async {
      await txn.rawInsert("""
        INSERT INTO Sales(Title, Price, Chosen_Date)
        VALUES(?, ?, ?)
      """, [title, price, chosen_date]);
    });
  }

  static Future<bool> deleteSales(Database database, int productId) async {
    int result = await database.delete(
      'Sales',
      where: 'Product_ID = ?',
      whereArgs: [productId],
    );
    return result == 1;
  }

  static Future<void> updateSalesData(Database database, int productId,
      String title, double price, String chosen_date) async {
    await database.transaction((txn) async {
      print(title);
      print(price);
      print(productId);
      print("updating....");
      await txn.rawUpdate('''
        UPDATE Sales 
        SET Title = ?, Price = ?, Chosen_Date = ?
        WHERE Product_ID = ?
      ''', [title, price, chosen_date, productId]);
    });
  }
}

class DatabaseHelper {

static Future<List<double>> getWeeklyTotalsFromDatabase() async {
    try {
      final List<SalesData> weeklySales = await DatabaseHelper.getWeeklySales();
      List<double> weeklyTotals = [0, 0, 0, 0]; // Initialize with default values

      if (weeklySales.isNotEmpty) {
        DateTime now = DateTime.now();
        // Calculate totals for each week separately
        for (int i = 0; i < weeklyTotals.length; i++) {
          double total = 0;
          for (var transaction in weeklySales) {
            DateTime transactionDate = DateTime.parse(transaction.chosen_date);
            int weekNumber = _calculateWeekNumber(transactionDate, now);
            if (weekNumber == i + 1) {
              total += transaction.price;
            }
          }
          weeklyTotals[i] = total;
        }
      } else {
        print("No weekly sales data available.");
      }

      return weeklyTotals;
    } catch (e) {
      print("Error fetching weekly totals from database: $e");
      throw e; // Throw the error to be caught by the caller
    }
  }

  static int _calculateWeekNumber(DateTime transactionDate, DateTime currentDate) {
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    int daysDifference = transactionDate.difference(firstDayOfMonth).inDays;
    int weekNumber = ((daysDifference + firstDayOfMonth.weekday) / 7).ceil();
    return weekNumber;
  }

  static Future<List<SalesData>> getWeeklySales() async {
    final db = await DatabaseHelperCreate.db();

    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the start and end date of the current week
    DateTime startDate = now.subtract(Duration(days: now.weekday));
    DateTime endDate = startDate.add(const Duration(days: 6));

    // Query to select price within the days of the current week
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT Price, Chosen_Date FROM Sales
      WHERE Chosen_Date BETWEEN ? AND ?
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    // Print the selected list
    print("Current Week Transactions:");
    print(maps);

    return List.generate(maps.length, (i) {
      return SalesData(
        price: maps[i]['Price'],
        chosen_date: maps[i]['Chosen_Date'],
        productID: 0,
        title: '',
      );
    });
  }

  static Future<List<SalesData>> getMonthlySales() async {
    final db = await DatabaseHelperCreate.db();

    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the start and end date of the current month
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime(now.year, now.month + 1, 0);

    // Query to select sales within the days of the current month
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT Product_ID, Title, Price, Chosen_Date FROM Sales
      WHERE Chosen_Date BETWEEN ? AND ?
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    // Print the selected list
    print("Monthly Sales:");
    print(maps);

    return List.generate(maps.length, (i) {
      return SalesData(
        productID: maps[i]['Product_ID'],
        title: maps[i]['Title'],
        price: maps[i]['Price'],
        chosen_date: maps[i]['Chosen_Date'],
      );
    });
  }

  static Future<void> insertSales(SalesData salesdata) async {
    final db = await DatabaseHelperCreate.db();
    await SQLHelper_dailySales.insertSalesData(
        db, salesdata.title, salesdata.price, salesdata.chosen_date);
    print("hello");
  }

  static Future<List<SalesData>> getSales() async {
    final db = await DatabaseHelperCreate.db();
    final List<Map<String, dynamic>> maps = await db.query('Sales');
    print("the list i am get sales function");
    print(maps);

    return List.generate(maps.length, (i) {
      return SalesData.fromMap(maps[i]);
      // return SalesData(
      //   productID: maps[i]['Product_ID'],
      //   title: maps[i]['Title'] ?? "",
      //   price: maps[i]['Price'] ?? "",
      //   chosen_date: maps[i]['Chosen_Date'] ?? "",
      // );
    });
  }

  static Future<bool> deleteSales(int productID) async {
    final db = await DatabaseHelperCreate.db();
    return await SQLHelper_dailySales.deleteSales(db, productID);

    // Update the local list of transactions by removing the deleted item

    // Call the callback function after deletion
  }
}

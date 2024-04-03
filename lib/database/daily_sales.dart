import 'package:flutter_styling/models/sales_data.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'databasecreate.dart';
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
}

class DatabaseHelper {
  static Future<void> insertSales(SalesData salesdata) async {
    final db = await DatabaseHelperCreate.db();
    await SQLHelper_dailySales.insertSalesData(
        db, salesdata.title, salesdata.price, salesdata.chosen_date);
    print("hello");
  }

  static Future<List<SalesData>> getSales() async {
    final db = await DatabaseHelperCreate.db();
    final List<Map<String, dynamic>> maps = await db.query('Sales');
    print("the list");
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

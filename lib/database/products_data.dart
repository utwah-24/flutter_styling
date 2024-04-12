import 'package:flutter_styling/database/database_create.dart';
import 'package:flutter_styling/models/product_data.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SQLHelper_products {
  static Future<void> createProductsTables(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS products(
        Product_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Product_name CHAR(20) NOT NULL,
        Product_amount CHAR(20) NOT NULL,
        Product_price REAL NOT NULL
      )""");
  }

  static Future<void> insertProData(Database database, String product_name,
      String product_amount, double product_price) async {
    await database.transaction((txn) async {
      await txn.rawInsert("""
        INSERT INTO products(product_name, product_amount, product_price)
        VALUES(?, ?, ?)
      """, [product_name, product_amount, product_price]);
    });
  }
}

class DatabaseHelper {
  // static Future<sql.Database> db() async {
  //   return sql.openDatabase(
  //     "sale_mate.db",
  //     version: 1,
  //     onCreate: (Database db, int version) async {
  //       print("Creating table...");
  //       await SQLHelper_products.createProductsTables(db);
  //     },
  //   );
  // }

  static Future<void> insertProducts(ProductData productdata) async {
    final db = await DatabaseHelperCreate.db();
    await SQLHelper_products.insertProData(db, productdata.product_name,
        productdata.product_amount, productdata.product_price as double);
  }

  // static Future<List<ProductData>> getProducts(
  //     String product_name, String product_amount, double product_price) async {
  //   final db = await DatabaseHelper.db();
  //   final List<Map<String, dynamic>> maps = await db.rawQuery(
  //       'SELECT * FROM products WHERE product_name = ? AND product_amount = ? AND product_price = ?',
  //       [product_name, product_amount, product_price]);
  //   print("the list");
  //   print(maps);

  //   return List.generate(maps.length, (i) {
  //     return ProductData(
  //       product_name: maps[i]['Product_name'] ?? "",
  //       product_amount: maps[i]['Product_amount'] ?? "",
  //       product_price: maps[i]['Product_price'] ?? "",
  //     );
  //   });
  // }
  static Future<List<ProductData>> getProducts() async {
  final db = await DatabaseHelperCreate.db();
  final List<Map<String, dynamic>> maps = await db.query('products');
  print("the list");
  print(maps);

  return List.generate(maps.length, (i) {
    return ProductData(
      product_name: maps[i]['Product_name'] ?? "",
      product_amount: maps[i]['Product_amount'] ?? "",
      product_price: maps[i]['Product_price'] ?? "",
    );
  });
}

}

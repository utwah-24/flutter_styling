import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'daily_sales.dart';
import 'products_data.dart';
import 'register.dart';

class DatabaseHelperCreate {
    static Future<sql.Database> db() async {
    return sql.openDatabase(  
      "sale_mate.db",
      version: 1,
      onCreate: (Database db, int version) async {
        print("Creating table...");
        await SQLHelper_dailySales.createSalesTables(db);
        await SQLHelper_products.createProductsTables(db);
        await SQLHelper_register.createRegisterTables(db); 
      },
    );
  }
}
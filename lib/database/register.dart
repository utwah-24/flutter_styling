import "package:sqflite/sqflite.dart" as sql;
import "package:sqflite/sqlite_api.dart";
import "package:flutter_styling/models/register_data.dart";
import 'databasecreate.dart';

class SQLHelper_register {
  static Future<void> createRegisterTables(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS register(
        Login_ID INTEGER PRIMARY KEY AUTOINCREMENT ,
        full_name VARCHAR(20) NOT NULL,
        email VARCHAR(20) NOT NULL,
        password VARCHAR(20) NOT NULL
      )""");
  }

  static Future<void> insertData(Database database, String full_name,
      String email, String password) async {
    await database.transaction((txn) async {
      await txn.rawInsert("""
        INSERT INTO register(full_name, email, password)
        VALUES(?, ?, ?)
      """, [full_name, email, password]);
    });
  }

  // static Future<RegisterData?> getUserByEmail(
  //     Database database, String email) async {
  //   List<Map<String, dynamic>> result = await database.query(
  //     "register",
  //     where: "email = ?",
  //     whereArgs: [email],
  //   );

  //   if (result.isEmpty) {
  //     return null;
  //   } else {
  //     return RegisterData.fromMap(result.first);
  //   }
  // }
}

class DatabaseHelper {
  // static Future<sql.Database> db() async {
  //   return sql.openDatabase(
  //     "sale-mate.db",
  //     version: 1,
  //     onCreate: (Database db, int version) async {
  //       // print("Creating table...");
  //       await SQLHelper3.createRegisterTables(db);
  //     },
  //   );
  // }

  static Future<bool> authenticateUser(String email, String password) async {
    try {
      final db = await DatabaseHelperCreate.db();
      List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM register WHERE email = ? AND password = ?",
        [email, password],
      );
  
      return result.isNotEmpty;
    } catch (e) {
      print("Error authenticating user: $e");
      throw e;
    }
  }

  static Future<void> insertRegister(RegisterData register) async {
    final db = await DatabaseHelperCreate.db();
    await SQLHelper_register.insertData(
        db, register.full_name, register.email, register.password);
  }

  // static Future<RegisterData?> getUserByEmail(String email) async {
  //   final db = await DatabaseHelper.db();
  //   return SQLHelper.getUserByEmail(db, email);
  // }
}

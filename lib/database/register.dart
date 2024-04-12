import 'dart:io';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter_styling/models/register_data.dart';
import 'database_create.dart';

class SQLHelper_register {
  static Future<void> createRegisterTables(Database database) async {
    await database.execute("""
      CREATE TABLE   register(
        Login_ID INTEGER PRIMARY KEY AUTOINCREMENT ,
        full_name VARCHAR(20) NOT NULL,
        email VARCHAR(20) NOT NULL,
        password VARCHAR(20) NOT NULL
      )""");
  }

  static Future<void> insertData(
    Database database,
    String full_name,
    String email,
    String password,
  ) async {
    // final profilePictureBytes = profilePicture != null ? await profilePicture.readAsBytes() : null;
    await database.transaction((txn) async {
      await txn.rawInsert("""
        INSERT INTO register(full_name, email, password)
        VALUES(?, ?, ?)
      """, [
        full_name,
        email,
        password,
      ]);
    });
  }

  // Add a method to retrieve user data by email
  static Future<RegisterData?> getUserByEmail(
      Database database, String email) async {
    List<Map<String, dynamic>> result = await database.query(
      "register",
      where: "email = ?",
      whereArgs: [email],
    );

    if (result.isEmpty) {
      return null;
    } else {
      return RegisterData.fromMap(result.first);
    }
  }
}

class DatabaseHelper {
  static Future<bool> authenticateUser(String email, String password) async {
    try {
      final db = await DatabaseHelperCreate.db();
      print(email);
      print(password);
      List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM register WHERE email = ? AND password = ?",
        [email, password],
      );

      // Check if the result contains any rows
      if (result.isNotEmpty) {
        // If there are rows, authentication successful
        return true;
      } else {
        // If there are no rows, authentication failed
        return false;
      }
    } catch (e) {
      // Catch any exceptions that occur during database access
      print("Error authenticating user: $e");
      throw e;
    }
  }

  static Future<void> insertRegister(
    RegisterData register,
  ) async {
    final db = await DatabaseHelperCreate.db();
    await SQLHelper_register.insertData(
        db, register.full_name, register.email, register.password);
  }

  // static Future<RegisterData?> getUserByEmail(String email) async {
  //   final db = await DatabaseHelperCreate.db();
  //   return SQLHelper_register.getUserByEmail(db, email);
  // }
}

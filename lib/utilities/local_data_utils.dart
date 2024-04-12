


import 'package:shared_preferences/shared_preferences.dart';

import '../models/register_data.dart';

class LocalDataUtils {

  Future<void> saveUserData(RegisterData registerData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', registerData.email);
    await prefs.setString('password', registerData.password);
    await prefs.setBool('rememberMe', registerData.rememberMe ?? false);
  }

  Future<RegisterData> getUserData()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    RegisterData registerData =
        RegisterData(
          full_name: "", 
          email: prefs.getString("email")??"",
          password: prefs.getString("password")??"",
          rememberMe: prefs.getBool("rememberMe")??false,
          );
          
    return registerData;
  }
}

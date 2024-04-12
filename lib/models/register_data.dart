import 'dart:async';
import 'dart:io';

class RegisterData {
  final String full_name;
  final String email;
  final String password;
  // final File? profilePicture;
  bool? rememberMe = false;

  RegisterData({
     required this.full_name,
    required this.email,
    required this.password,
    // this.profilePicture,
    this.rememberMe,
  });

  Map<String, dynamic> toMap() {
    return {
      'full_name': full_name,
      'email': email,
      'password': password,
      // 'profile_picture': profilePicture != null ? profilePicture!.path : null,
    };
  }
  factory RegisterData.fromMap(Map<String, dynamic> map) {
    return RegisterData(
      full_name: map['full_name'],
      email: map['email'],
      password: map['password'],
      // profilePicture:
      //     map['profile_picture'] != null ? File(map['profile_picture']) : null,
    );
  }
}

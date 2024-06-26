import 'dart:typed_data';

class RegisterData {
  final String full_name;
  final String email;
  final String password;
  final Uint8List? profilePicture; // Updated property for profile picture
  bool? rememberMe = false;

  RegisterData({
    required this.full_name,
    required this.email,
    required this.password,
    this.profilePicture, // Updated constructor parameter for profile picture
    this.rememberMe,
  });

  Map<String, dynamic> toMap() {
    return {
      'full_name': full_name,
      'email': email,
      'password': password,
      'profile_picture': profilePicture, // Updated to include profile picture
    };
  }

  factory RegisterData.fromMap(Map<String, dynamic> map) {
    return RegisterData(
      full_name: map['full_name'],
      email: map['email'],
      password: map['password'],
      profilePicture: map['profile_picture'], // Updated to include profile picture
    );
  }
}

// ignore_for_file: non_constant_identifier_names

class RegisterData {
  
  final String full_name;
  final String email;
  final String password;

  RegisterData(
      { required this.full_name, required this.email, required this.password});

       Map<String, dynamic> toMap() {
    return {
      
      'full_name': full_name,
      'email': email,
      'password': password,
    };
  }

  factory RegisterData.fromMap(Map<String, dynamic> map) {
    return RegisterData(
   
      full_name: map['full_name'],
      email: map['email'],
      password: map['password'],
    );
  }
}


// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_styling/models/register_data.dart';
import 'package:flutter_styling/database/register.dart';
import 'package:flutter_styling/widgets/Login.dart';
import 'package:image_picker/image_picker.dart';
import '../utilities/util.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isPasswordVisible = false;
  final bool _rememberMe = false;
  Uint8List? _image;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void selectImage() async {
  Uint8List img = await pickImage(ImageSource.gallery);
  setState(() {
    _image = img;
  });
}

Future<void> connectData() async {
  String full_name = _fullNameController.text;
  String email = _emailController.text;
  String password = _passwordController.text;

  if (_passwordController.text != _reEnterPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Passwords do not match!'),
      ),
    );
  } else {
    try {
      await DatabaseHelper.insertRegister(RegisterData(
        full_name: full_name,
        email: email,
        password: password,
        profilePicture: _image, // Pass the selected image here
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed. Please try again.'),
        ),
      );
      print('Error inserting data into database: $e');
    }
  }
}


  Widget _gap() => const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(50),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Register to Sale-Mate!",
                    textAlign: TextAlign.center,
                    style: isSmallScreen
                        ? Theme.of(context).textTheme.headline6
                        : Theme.of(context).textTheme.headline5,
                  ),
                )
              ],
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              child: Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://th.bing.com/th/id/OIP.uCTjB8_lMSeGyrbgGJVisgAAAA?w=145&h=166&c=7&r=0&o=5&dpr=1.1&pid=1.7'),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Full name',
                          hintText: 'Enter your 3 names',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      _gap(),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      _gap(),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      _gap(),
                      TextFormField(
                        controller: _reEnterPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Re-Enter password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      _gap(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              connectData();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: TextButton(
                          child: Text('back to sign in '),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

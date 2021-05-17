import 'dart:io';

import 'package:flutter/material.dart';

import 'package:zuri_chat_app/services/AuthService.dart';
import 'package:zuri_chat_app/views/homepage.dart';
import 'package:zuri_chat_app/views/signIn.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  bool isLoading = false;
  AuthService _authService = AuthService();
  File _image = File('');
  final picker = ImagePicker();
  bool _isHidden = true;

  signUp() async {
      await _authService.signUpEmailAndPassword(
        username: usernameController.text,
        email: emailController.text, 
        password: passwordController.text,
      ).then((value) {
        if (value != null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else return null;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator.adaptive(),),
      ) :
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Spacer(),
            Expanded(
              flex: 2,
              child: Center(
              child: GestureDetector(
                onTap: () => _showPicker(context),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xfffFDCF09),
                  child: _image.path.isNotEmpty ? 
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      ) : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.grey[800],
                        ),
                      )
                )
              )
            ),
            ),
            
            SizedBox(height: 8),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    style: globalTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white70),
                      )
                    ),
                    controller: usernameController,
                    validator: (val){
                      return val!.isEmpty || val.length < 3 ? "Enter username" : null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    style: globalTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white70),
                      )
                    ),
                    controller: emailController,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: _isHidden,
                    validator: (val) {
                      return val!.length > 6 ? null 
                      : 'Enter password of more than 6 characters';
                    },
                    style: globalTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      suffix: InkWell(
                        onTap: () => toggleShowPassword(),
                        child: _isHidden ? 
                            Icon(Icons.visibility_off) :
                            Icon(Icons.visibility),
                      ),
                    ),
                    controller: passwordController,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
         
            Container(
              child: ElevatedButton(
                autofocus: true,
                style: ButtonStyle(),
                child: Text('Sign up'),
                onPressed: () => signUp(),
              ),
            ),
            
            // SizedBox(height: 0.6),
            
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                    // padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return SignIn();
                                })
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
            
                ],                    
              ),
            ),
            
            // SizedBox(height: 14),
            
            
          ],
          
        ),
      )
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
    
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext _build) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Library'),
                  onTap: () {
                    getImage();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera_rounded),
                  title: Text('Camera'),
                  onTap: () {
                    getImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void toggleShowPassword() => setState(() => _isHidden = !_isHidden);
}


TextStyle globalTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal);
}

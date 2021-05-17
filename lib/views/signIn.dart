import 'package:flutter/material.dart';
import 'package:zuri_chat_app/views/homepage.dart';

import 'package:zuri_chat_app/views/signup.dart';
import 'package:zuri_chat_app/services/AuthService.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthService _authService = AuthService();

  signIn() async {
    await _authService.signinWithEmail(
      emailController.text, passwordController.text).then((value) {
        if (value != null) {
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) => HomePage()));
        } else return null;
      });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Spacer(),
            Form(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                children: [
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
                    obscureText: true,
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
                    ),
                    controller: passwordController,
                  ),
                ],
              ),
              )
              
            ),
            // SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    // vertical: 8,
                  ),
                  child: Text('Forgot Password', style: globalTextStyle()),
                )
              ]
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              // width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                autofocus: true,
                style: ButtonStyle(),
                child: Text('Sign In'),
                onPressed: () => signIn(),
              ) 
            ),
          
            // SizedBox(height: 16),
            
            /*Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Sign in with Google',
                style: globalTextStyle(),
                textAlign: TextAlign.center
              ),
            ),*/
            //SizedBox(height: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return SignUp();
                        })
                      );
                    },
                    child: Text(
                      'Register here',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        decoration: TextDecoration.underline
                      ),
                    )
                  )
                  
                ],
              ),
            ),
            SizedBox(height: 16),
          ]
        ),
      )
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}


TextStyle globalTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal);
}

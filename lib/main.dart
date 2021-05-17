import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:zuri_chat_app/views/homepage.dart';
import 'package:zuri_chat_app/views/signIn.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child: Center(child: 
              Text('Something went wrong, ${snapshot.error}', 
                textDirection: TextDirection.ltr,
              )
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          if (_auth.currentUser != null) {
            print(_auth.currentUser!.uid);
            isLoggedIn = true;
          }
          _auth.authStateChanges()
          .listen((User? user) { 
            if (user == null) {
              print('User is currently signed out');
              isLoggedIn = false;     
            } else {
              print('User is signed in: ${user.uid}');
              isLoggedIn = true;
            }
          });
          return MaterialApp(
            title: 'QwikChat',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xff1F1F1F),
            ),
            home: isLoggedIn ? HomePage() : SignIn(),
            debugShowCheckedModeBanner: false,
          );
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          )
        );
      }
    );
  }
}


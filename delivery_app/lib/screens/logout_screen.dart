import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/screens/register_screen.dart';

class LogOutScreen extends StatelessWidget {
  static const String id = 'logout-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, RegisterScreen.id);
          },
          child: Text('Log Out'),
        ),
      ),
    );
  }
}

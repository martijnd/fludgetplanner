import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fludgetplanner/auth.dart';

import 'package:fludgetplanner/pages/LandingPage.dart';
import 'package:fludgetplanner/pages/LoggedOutPage.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Google Sign In',
      home: Fludgetplanner(),
    ),
  );
}

class Fludgetplanner extends StatefulWidget {
  @override
  _FludgetplannerState createState() => _FludgetplannerState();
}

class _FludgetplannerState extends State<Fludgetplanner> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    authService.currentUser
        .listen((state) => setState(() => _currentUser = state));
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      return LandingPage(currentUser: _currentUser);
    } else {
      return LoggedOutPage();
    }
  }
}

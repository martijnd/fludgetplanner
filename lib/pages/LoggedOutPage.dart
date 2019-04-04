import 'package:fludgetplanner/auth.dart';
import 'package:fludgetplanner/components/RaisedGradientButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoggedOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFC0392B), Color(0xFF8E44AD)],
                begin: Alignment.topLeft)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text(
              "Fludgetplanner",
              style: TextStyle(
                  fontFamily: 'Pacifico', color: Colors.white, fontSize: 40),
            ),
            RaisedGradientButton(
              width: 200.0,
              height: 100.0,
              gradient: LinearGradient(
                  colors: [Color(0xFF8E44AD), Color(0xFFC0392B)],
                  begin: Alignment.topLeft),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Text(
                'INLOGGEN',
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
              onPressed: () => authService.signIn(),
            ),
          ],
        ),
      ),
    ));
  }
}

import 'package:fludgetplanner/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoggedOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fludgetplanner'),
          actions: <Widget>[],
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("You are not currently signed in."),
                MaterialButton(
                  color: Colors.primaries[5],
                  child: Text('SIGN IN'),
                  onPressed: () => authService.signIn(),
                ),
              ],
            ),
          ),
        ));
  }
}

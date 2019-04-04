import 'package:fludgetplanner/auth.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.currentUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
        } else {
          return IconButton(
            icon: Icon(Icons.person),
            onPressed: authService.signOut,
          );
        }
      },
    );
  }
}

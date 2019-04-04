import 'package:fludgetplanner/auth.dart';
import 'package:fludgetplanner/components/RaisedGradientButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flare_flutter/flare_actor.dart';

class LoggedOutPage extends StatelessWidget {
  List<Color> _getGradient(bool reverse) {
    Color color1 = Colors.blue;
    Color color2 = Colors.blue[200];
    if (!reverse)
      return [color1, color2];
    else
      return [color2, color1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: _getGradient(false), begin: Alignment.topLeft)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Fludgetplanner",
                style: TextStyle(
                    fontFamily: 'Pacifico', color: Colors.white, fontSize: 40),
              ),
              _buildLoadingAnimation(),
              RaisedGradientButton(
                width: 200.0,
                height: 100.0,
                gradient: LinearGradient(
                    colors: [Colors.blue[400], Colors.blue[400]],
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
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return SizedBox(
      height: 300.0,
      width: 400.0,
      child: FlareActor(
        "assets/loading.flr",
        alignment: Alignment.center,
        animation: "Animation",
        fit: BoxFit.contain,
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.borderRadius,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: Offset(0.0, 1.5),
                    blurRadius: 1.5,
                  )
                ],
              ),
              child: Center(child: child),
            )),
      ),
    );
  }
}

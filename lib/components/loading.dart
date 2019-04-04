import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';

Widget loadingAnimation() {
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

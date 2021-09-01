import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColors {

  static Map<int, Color> baseRed =
  {
    50:Color.fromRGBO(92,22,23, .1),
    100:Color.fromRGBO(92,22,23, .2),
    200:Color.fromRGBO(92,22,23, .3),
    300:Color.fromRGBO(92,22,23, .4),
    400:Color.fromRGBO(92,22,23, .5),
    500:Color.fromRGBO(92,22,23, .6),
    600:Color.fromRGBO(92,22,23, .7),
    700:Color.fromRGBO(92,22,23, .8),
    800:Color.fromRGBO(92,22,23, .9),
    900:Color.fromRGBO(92,22,23, 1),
  };

  static MaterialColor customRed = MaterialColor(0xFF741920, baseRed);
}




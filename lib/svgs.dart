import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

const List<String> iconNames = <String>[
  'assets/svg/animals/AngryKangaroo.svg',
  'assets/svg/animals/Bear.svg',
  'assets/svg/animals/BrownSnake.svg',
  'assets/svg/animals/ButterFly.svg',
  'assets/svg/animals/Camel.svg',
  'assets/svg/animals/Cat.svg',
  'assets/svg/animals/Dog.svg',
  'assets/svg/animals/Elephant.svg',
  'assets/svg/animals/Giraff.svg',
  'assets/svg/animals/GreenSnake.svg',
  'assets/svg/animals/Lion.svg',
  'assets/svg/animals/Mouse.svg',
  'assets/svg/animals/Panda.svg',
  'assets/svg/animals/Papegoja.svg',
  'assets/svg/animals/Pelican.svg',
  'assets/svg/animals/Pig.svg',
  'assets/svg/animals/RedSnake.svg',
  'assets/svg/animals/Rhino.svg',
  'assets/svg/animals/Spider.svg',
  'assets/svg/animals/WhiteRabbit.svg',
  'assets/svg/animals/YellowBird.svg',
  'assets/svg/animals/YellowSnake.svg',
];

class SVGs {
  static final List<Widget> painters = <Widget>[];

  SVGs() {
    for (int i = 0; i < iconNames.length; i++) {
      painters.add(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SvgPicture.asset(
            iconNames[i],
            //color: Colors.blueGrey[(i + 1) * 100],
            matchTextDirection: true,
          ),
        ),
      );
    }
  }
}

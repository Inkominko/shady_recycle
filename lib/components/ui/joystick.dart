import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class Joystick extends Component with HasGameRef<ShadyRecycleGame> {
  late final JoystickComponent joystickComponent;

  Joystick(Game game) {
    final knobPaint = Paint()..color = Colors.black;
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);
    joystickComponent = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 10, bottom: 10),
    );
  }
}
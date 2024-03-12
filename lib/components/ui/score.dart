import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:shady_recycle/components/ui/pause_button.dart';
import 'package:shady_recycle/constants.dart';
import '../../main.dart';
import '../../screens/game_screen.dart';

class Score extends Component with HasGameRef<ShadyRecycleGame> {
  Score({required this.gameScreen});

  final GameScreen gameScreen;

  int score = 0;
  double fontSize = 24;
  Color color = Color(blackColor);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final textStyle = TextStyle(fontSize: fontSize, color: color);
    final textSpan =
        TextSpan(text: score.toString().padLeft(4, '0'), style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(screenWidth! / 2 - textPainter.width / 2,
            Pause(gameScreen: gameScreen).offSet));
  }

  @override
  void update(double dt) {
    super.update(dt);
    score = updateScore;
  }
}

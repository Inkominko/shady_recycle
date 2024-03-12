import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/input.dart';
import '../../constants.dart';
import '../../main.dart';
import '../../screens/game_screen.dart';

class Exit extends SpriteButtonComponent with HasGameRef<ShadyRecycleGame> {
  Exit({required this.gameScreen});

  final GameScreen gameScreen;
  double offSet = 10;

  @override
  void onLoad() async {
    button = await gameRef.loadSprite('ui/exit.png');
    size = vectorHeightSizeAdjustment(40, button);
    position = Vector2(size.x / 2 + offSet, scaledSize.y / 2 + offSet);
    anchor = Anchor.center;

    onPressed = () async {
      if (!isExitDialogShown && !isHelpDialogShown) {
        FlameAudio.play('tap.wav', volume: 0.3);
        gameRef.resumeEngine();
        gameScreen.add(ExitDialog(gameScreen: gameScreen));
        gameRef.camera.viewport.removeAll(gameScreen.addUiList);
        isExitDialogShown = true;
        Timer(const Duration(milliseconds: 100), () {
          gameRef.pauseEngine();
        });
      }
    };
  }
}

class ExitDialog extends Component with HasGameRef<ShadyRecycleGame> {
  final GameScreen gameScreen;

  ExitDialog({required this.gameScreen});

  @override
  void render(Canvas canvas) {
    Paint background = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, screenWidth!, screenHeight!), background);

    Paint fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    double rectWidth = 450;
    double rectHeight = 180;
    double borderRadius = 20;

    double rectLeft = screenWidth! / 2 - rectWidth / 2;
    double rectTop = screenHeight! / 2 - rectHeight / 2;

    RRect fillRRect = RRect.fromLTRBR(
      rectLeft + 1,
      rectTop + 1,
      rectLeft + rectWidth - 1,
      rectTop + rectHeight - 1,
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(fillRRect, fillPaint);

    TextSpan titleSpan = const TextSpan(
      text: 'ARE YOU SURE YOU WANT TO QUIT',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
    TextPainter titlePainter =
        TextPainter(text: titleSpan, textDirection: TextDirection.ltr);
    titlePainter.layout();
    titlePainter.paint(
        canvas,
        Offset(
            screenWidth! / 2 - titlePainter.width / 2, screenHeight! / 2 - 70));

    TextSpan contentSpan = const TextSpan(
      text: 'SESSION WILL NOT BE SAVED',
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
    TextPainter contentPainter =
        TextPainter(text: contentSpan, textDirection: TextDirection.ltr);
    contentPainter.layout(maxWidth: 250);
    contentPainter.paint(
        canvas,
        Offset(screenWidth! / 2 - contentPainter.width / 2,
            screenHeight! / 2 - 40));
  }

  @override
  Future<void> onLoad() async {
    Sprite staySprite = await gameRef.loadSprite('ui/stay_button.png');
    Sprite exitSprite = await gameRef.loadSprite('ui/quit_button.png');

    addAll([
      SpriteButtonComponent(
          button: staySprite,
          position: Vector2(screenWidth! / 2 - 100, screenHeight! / 2 + 10),
          size: vectorHeightSizeAdjustment(100, staySprite),
          anchor: Anchor.topCenter,
          onPressed: () async {
            FlameAudio.play('tap.wav', volume: 0.3);
            gameRef.resumeEngine();
            isExitDialogShown = false;
            gameScreen.removeWhere((component) => component is ExitDialog);
            await gameRef.camera.viewport.addAll(gameScreen.addUiList);
            Timer(const Duration(milliseconds: 100), () {
              gameRef.pauseEngine();
            });
          }),
      SpriteButtonComponent(
          button: exitSprite,
          position: Vector2(screenWidth! / 2 + 100, screenHeight! / 2 + 10),
          size: vectorHeightSizeAdjustment(100, exitSprite),
          anchor: Anchor.topCenter,
          onPressed: () async {
            FlameAudio.play('tap.wav', volume: 0.3);
            gameRef.resumeEngine();
            isExitDialogShown = false;
            isPaused = false;
            isMusic = true;
            gameScreen.removeWhere((component) => component is ExitDialog);
            await gameRef.camera.viewport.addAll(gameScreen.addUiList);
            gameScreen.gameOverClear();
            FlameAudio.bgm.play('shady_theme_song.WAV');
            game.router.popUntilNamed('home_screen');
          })
    ]);
  }
}

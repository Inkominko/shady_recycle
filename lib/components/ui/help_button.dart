import 'dart:async';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/input.dart';
import '../../constants.dart';
import '../../main.dart';
import '../../screens/game_screen.dart';

class Help extends SpriteButtonComponent with HasGameRef<ShadyRecycleGame> {
  Help({required this.gameScreen});

  final GameScreen gameScreen;
  double offSet = 10;

  @override
  void onLoad() async {
    button = await gameRef.loadSprite('ui/help.png');
    size = vectorHeightSizeAdjustment(40, button);
    position = Vector2(2 * size.x + offSet, scaledSize.y / 2 + offSet);
    anchor = Anchor.center;

    onPressed = () async {
      if (!isExitDialogShown && !isHelpDialogShown) {
        FlameAudio.play('tap.wav', volume: 0.3);
        gameRef.resumeEngine();
        gameScreen.add(HelpDialog(gameScreen: gameScreen));
        gameRef.camera.viewport.removeAll(gameScreen.addUiList);
        isHelpDialogShown = true;
        Timer(const Duration(milliseconds: 100), () {
          gameRef.pauseEngine();
        });
      }
    };
  }
}

class HelpDialog extends Component with HasGameRef<ShadyRecycleGame> {
  final GameScreen gameScreen;

  HelpDialog({required this.gameScreen});

  double windowWidth = 600;
  double windowHeight = 350;
  double windowBorderRadius = 20;

  late Sprite instructionsSprite;
  @override
  Future<void> onLoad() async {
    Sprite closeSprite = await gameRef.loadSprite('ui/close_dialog.png');
    instructionsSprite =
        await gameRef.loadSprite('ui/instructions.png');

    add(SpriteButtonComponent(
        button: closeSprite,
        position: Vector2(screenWidth! / 2 + 600 / 2 - 15,
            screenHeight! / 2 - windowHeight / 2 + 15),
        size: vectorHeightSizeAdjustment(40, closeSprite),
        anchor: Anchor.topRight,
        onPressed: () async {
          FlameAudio.play('tap.wav', volume: 0.3);
          gameRef.resumeEngine();
          isHelpDialogShown = false;
          gameScreen.removeWhere((component) => component is HelpDialog);
          await gameRef.camera.viewport.addAll(gameScreen.addUiList);
          Timer(const Duration(milliseconds: 100), () {
            gameRef.pauseEngine();
          });
        }));
  }

  @override
  void render(Canvas canvas) {
    Paint background = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, screenWidth!, screenHeight!), background);

    Paint window = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    double windowLeft = screenWidth! / 2 - windowWidth / 2;
    double windowTop = screenHeight! / 2 - windowHeight / 2;

    RRect windowRRect = RRect.fromLTRBR(
      windowLeft + 1,
      windowTop + 1,
      windowLeft + windowWidth - 1,
      windowTop + windowHeight - 1,
      Radius.circular(windowBorderRadius),
    );

    canvas.drawRRect(windowRRect, window);

    TextSpan titleSpan = const TextSpan(
      text: 'HOW TO PLAY',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
    TextPainter titlePainter =
        TextPainter(text: titleSpan, textDirection: TextDirection.ltr);
    titlePainter.layout();
    titlePainter.paint(
        canvas,
        Offset(
            screenWidth! / 2 - titlePainter.width / 2,
            screenHeight! / 2 -
                windowHeight / 2 +
                titlePainter.size.height));

    instructionsSprite.render(canvas,
        position: Vector2(screenWidth! / 2, screenHeight! / 2 + 20),
        size: vectorHeightSizeAdjustment(550, instructionsSprite),
        anchor: Anchor.center);
  }
}

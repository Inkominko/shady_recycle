import 'package:flame/components.dart' hide Timer;
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:async';
import '../constants.dart';
import '../main.dart';

class GameOver extends Component with HasGameRef<ShadyRecycleGame> {
  late SpriteComponent eyeComponent;
  late SpriteComponent gameOverComponent;

  int gameOverDelay = 10;

  @override
  Future<void> onMount() async {
    FlameAudio.bgm.play('shady_theme_song.WAV');
    Sprite eyesSprite = await gameRef.loadSprite('ui/sad_eyes.png');
    Sprite gameOverSprite = await gameRef.loadSprite('ui/game_over.png');

    addAll([
      Background(Color(blackColor)),
      eyeComponent = SpriteComponent(
          sprite: eyesSprite,
          size: vectorHeightSizeAdjustment(300, eyesSprite),
          position: Vector2(
              gameRef.canvasSize.x / 2,
              gameRef.canvasSize.y / 2 -
                  vectorHeightSizeAdjustment(300, eyesSprite).y / 4))
        ..anchor = Anchor.bottomCenter,
      gameOverComponent = SpriteComponent(
          sprite: gameOverSprite,
          size: vectorHeightSizeAdjustment(300, gameOverSprite),
          position:
          Vector2(gameRef.canvasSize.x / 2, gameRef.canvasSize.y / 2 + 50))
        ..anchor = Anchor.topCenter,
    ]);

    Timer(Duration(seconds: gameOverDelay), () {
      game.router.popUntilNamed('home_screen');
    });
  }
}
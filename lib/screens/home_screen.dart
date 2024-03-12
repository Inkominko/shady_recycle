import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../main.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

class HomeScreen extends Component
    with TapCallbacks, HasGameRef<ShadyRecycleGame> {
  @override
  Future<void> onLoad() async {
    getScreenSize();
    Sprite eyesSprite = await gameRef.loadSprite('ui/eyes.png');
    Sprite playSprite = await gameRef.loadSprite('ui/play_button.png');
    Sprite exitSprite = await gameRef.loadSprite('ui/exit_button.png');

    addAll([
      Background(Color(blackColor)),
      SpriteComponent(
          sprite: eyesSprite,
          size: vectorHeightSizeAdjustment(300, eyesSprite),
          position: Vector2(
              gameRef.canvasSize.x / 2,
              gameRef.canvasSize.y / 2 -
                  vectorHeightSizeAdjustment(300, eyesSprite).y / 4))
        ..anchor = Anchor.bottomCenter,
      SpriteButtonComponent(
          button: playSprite,
          position:
          Vector2(screenWidth! / 2 - 150, screenHeight! / 2 + 50),
          size: vectorHeightSizeAdjustment(100, playSprite),
          anchor: Anchor.topCenter,
          onPressed: () async {
            FlameAudio.play('tap.wav', volume: 0.3);
            isGameOver = false;
            await FlameAudio.bgm.stop();
            game.router.pushNamed('game_screen');
          }),
      SpriteButtonComponent(
          button: exitSprite,
          position:
              Vector2(screenWidth! / 2 + 150, screenHeight! / 2 + 50),
          size: vectorHeightSizeAdjustment(100, exitSprite),
      anchor: Anchor.topCenter,
      onPressed: ()async {
        FlameAudio.play('tap.wav', volume: 0.3);
        await FlameAudio.bgm.stop();
        FlutterExitApp.exitApp(iosForceExit: true);
      })
    ]);
  }
}

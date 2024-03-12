import 'dart:async';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shady_recycle/components/ui/music_button.dart';
import '../../constants.dart';
import '../../main.dart';
import '../../screens/game_screen.dart';
import 'exit_button.dart';
import 'help_button.dart';

class Pause extends SpriteButtonComponent with HasGameRef<ShadyRecycleGame> {
  Pause({required this.gameScreen});

  final GameScreen gameScreen;
  double offSet = 10;

  @override
  void onLoad() async {
    Sprite pauseButton = await gameRef.loadSprite('ui/pause.png');
    Sprite resumeButton = await gameRef.loadSprite('ui/resume.png');

    button = pauseButton;
    size = vectorHeightSizeAdjustment(40, button);
    position = Vector2(size.x / 2 + offSet, scaledSize.y / 2 + offSet);
    anchor = Anchor.center;

    onPressed = () async {
      if (!isExitDialogShown && !isHelpDialogShown) {
        FlameAudio.play('tap.wav', volume: 0.3);
        isPaused = !isPaused;
        if (isPaused) {
          button = resumeButton;
          position = Vector2(5 * size.x + offSet, scaledSize.y / 2 + offSet);
          await gameScreen.add(Exit(gameScreen: gameScreen));
          await gameScreen.add(Help(gameScreen: gameScreen));
          await gameScreen.add(MusicButton());
          Timer(const Duration(milliseconds: 100), () {
            gameRef.pauseEngine();
          });
        } else {
          button = pauseButton;
          gameScreen.removeWhere((component) => component is Exit);
          gameScreen.removeWhere((component) => component is Help);
          gameScreen.removeWhere((component) => component is MusicButton);
          position = Vector2(size.x / 2 + offSet, scaledSize.y / 2 + offSet);
          gameRef.resumeEngine();
        }
      }
    };
  }
}

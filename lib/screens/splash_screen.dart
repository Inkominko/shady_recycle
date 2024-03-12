import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import '../constants.dart';
import '../main.dart';

class SplashScreen extends Component with HasGameRef<ShadyRecycleGame> {
  final double fadeInSpeed = 0.002;
  late SpriteComponent eyeComponent;
  late SpriteComponent titleComponent;
  bool eyeOpacityIsCompleted = false;
  bool titleOpacityIsCompleted = false;

  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.play('shady_theme_song.WAV');
    Sprite eyesSprite = await gameRef.loadSprite('ui/eyes.png');
    Sprite titleSprite = await gameRef.loadSprite('ui/title.png');

    addAll([
      Background(Color(blackColor)),
      eyeComponent = SpriteComponent(
          sprite: eyesSprite,
          size: vectorHeightSizeAdjustment(300, eyesSprite),
          position: Vector2(
              gameRef.canvasSize.x / 2,
              gameRef.canvasSize.y / 2 -
                  vectorHeightSizeAdjustment(300, eyesSprite).y / 4))
        ..anchor = Anchor.bottomCenter
        ..opacity = 0.0,
      titleComponent = SpriteComponent(
          sprite: titleSprite,
          size: vectorHeightSizeAdjustment(300, titleSprite),
          position:
              Vector2(gameRef.canvasSize.x / 2, gameRef.canvasSize.y / 2 + 20))
        ..anchor = Anchor.topCenter
        ..opacity = 0.0,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (eyeComponent.opacity < 1.0) {
      eyeComponent.opacity += fadeInSpeed;
      if (eyeComponent.opacity >= 1.0) {
        eyeOpacityIsCompleted = true;
      }
    }

    if (titleComponent.opacity < 1.0 && eyeOpacityIsCompleted && !titleOpacityIsCompleted) {
      titleComponent.opacity += fadeInSpeed;
      if (titleComponent.opacity >= 1.0){
        titleOpacityIsCompleted = true;
        return game.router.pushNamed('home_screen');
      }
    }
  }
}

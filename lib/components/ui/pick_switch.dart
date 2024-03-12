import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../constants.dart';
import '../../main.dart';

class SwitchPick extends SpriteButtonComponent
    with HasGameRef<ShadyRecycleGame> {
  double offSet = 10;

  @override
  void onLoad() async {
    Sprite pick = await gameRef.loadSprite('ui/pick.png');
    Sprite notPick = await gameRef.loadSprite('ui/not_pick.png');
    button = pick;
    size = vectorHeightSizeAdjustment(40, button);
    position = Vector2(
        screenWidth! - offSet - size.x/2, screenHeight! - offSet - size.y/2);
    anchor = Anchor.center;

    onPressed = () async {
      if(!isPaused){
        FlameAudio.play('tap.wav', volume: 0.3);
        isPickingTrash = !isPickingTrash;
        if (isPickingTrash) {
          button = pick;
        } else {
          button = notPick;
        }
      }
    };
  }
}

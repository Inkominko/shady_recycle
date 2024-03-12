import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../constants.dart';
import '../main.dart';
import 'bag.dart';

class Powers extends SpriteComponent
    with HasGameRef<ShadyRecycleGame>, CollisionCallbacks {
  bool isInBag = false;
  String type = '';

  void sizeAdjustment() {
    height = sprite!.srcSize.y * (powerSize / sprite!.srcSize.x);
    width = powerSize;
  }

  bool isExcludedPosition(double x, double y) {
    for (final excludedPos in trashcanPositions) {
      double distance = (Vector2(x, y) - excludedPos).length;
      if (distance < trashcanSize + 10) {
        return true;
      }
    }
    return false;
  }

  Vector2 powerPosition() {
    final Random randomTarget = Random();
    double randomTargetX, randomTargetY;
    do {
      randomTargetX = randomTarget.nextDouble() *
          (gameRef.size.x -
              (gameRef.size.x - (Bag().bagWidth / 2 + Bag().bagX)));
      randomTargetY = randomTarget.nextDouble() * gameRef.size.y;
    } while (isExcludedPosition(randomTargetX, randomTargetY));
    return Vector2(randomTargetX, randomTargetY);
  }

  @override
  Future<void> onLoad() async {
    Random random = Random();
    int randomIndex;

    do {
      randomIndex = random.nextInt(powerList.length);
    } while (powerList[randomIndex]['isAdded']);

    if (powerList[randomIndex]['type'] == 'destroy_enemy') {
      powerList[randomIndex]['isAdded'] = true;
    }

    sprite = await gameRef.loadSprite(powerList[randomIndex]['path']);
    type = powerList[randomIndex]['type'];

    anchor = Anchor.center;
    sizeAdjustment();
    position = powerPosition();
    FlameAudio.play('super_power.wav');
    add(RectangleHitbox());
  }
}

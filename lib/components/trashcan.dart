import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../constants.dart';
import '../main.dart';

class Trashcan extends SpriteComponent
    with HasGameRef<ShadyRecycleGame>, CollisionCallbacks {
  Trashcan({required Vector2 position, required this.trashcanPath, required this.trashcanType})
      : super(
          position: position,
          size: Vector2.all(trashcanSize),
          anchor: Anchor.center,
        );
  String trashcanPath;
  String trashcanType;
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(trashcanPath);
    add(RectangleHitbox());
  }
}

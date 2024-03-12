import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shady_recycle/components/powers.dart';
import 'package:shady_recycle/components/player.dart';
import 'package:shady_recycle/components/trash.dart';
import 'dart:async';
import '../constants.dart';
import '../main.dart';
import '../screens/game_screen.dart';
import 'bag.dart';

class Enemy extends SpriteComponent
    with HasGameRef<ShadyRecycleGame>, CollisionCallbacks {
  Enemy(
      {required this.enemyList,
      required this.index,
      required this.gameScreen,
      required this.addList})
      : super(anchor: Anchor.center);

  List enemyList;
  int index;
  GameScreen gameScreen;
  List<Component> addList;

  late final Sprite move1;
  late final Sprite move2;
  late final Sprite cloud;

  late List<Sprite> moveSprites;
  int currentMoveSpriteIndex = 0;

  double spriteChangeDelay = 0.1;
  double timeSinceLastSpriteChange = 0.0;

  late Vector2 targetPosition;
  String enemyType = '';
  String enemyColor = '';
  double enemySize = 0.0;
  bool enemyBeingDestroyed = false;

  int randomTargetCounter = 0;

  void sizeAdjustment() {
    height = sprite!.srcSize.y * (enemySize / sprite!.srcSize.x);
    width = enemySize;
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

  void randomTargetPosition() {
    final Random randomTarget = Random();
    double randomTargetX, randomTargetY;
    do {
      randomTargetX = randomTarget.nextDouble() *
          (gameRef.size.x -
              (gameRef.size.x - (Bag().bagWidth / 2 + Bag().bagX)));
      randomTargetY = randomTarget.nextDouble() * gameRef.size.y;
    } while (isExcludedPosition(randomTargetX, randomTargetY));
    targetPosition = Vector2(randomTargetX, randomTargetY);
    randomTargetCounter++;
  }

  @override
  Future<void> onLoad() async {
    move1 = await gameRef.loadSprite(enemyList[index]['move1']);
    move2 = await gameRef.loadSprite(enemyList[index]['move2']);
    cloud = await gameRef.loadSprite(enemyList[index]['cloud']);

    sprite = move1;
    moveSprites = [move1, move2];
    enemySize = enemyList[index]['size'];
    sizeAdjustment();
    position = Vector2(gameRef.size.x + (enemyList[index]['size'] * 2),
        gameRef.size.y + (enemyList[index]['size'] * 2));

    enemyType = enemyList[index]['type'];
    enemyColor = enemyList[index]['color'];
    randomTargetPosition();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (enemyBeingDestroyed) {
      sprite = cloud;
      enemySize -= 1;
      sizeAdjustment();
    } else {
      Vector2 direction = targetPosition - position;
      direction.normalize();

      position += direction * enemyList[index]['speed'] * dt;

      angle = atan2(-direction.x, direction.y);

      timeSinceLastSpriteChange += dt;
      if (timeSinceLastSpriteChange >= spriteChangeDelay) {
        currentMoveSpriteIndex =
            (currentMoveSpriteIndex + 1) % moveSprites.length;
        sprite = moveSprites[currentMoveSpriteIndex];
        timeSinceLastSpriteChange = 0.0;
      }

      if ((targetPosition - position).length < 1.0) {
        if (randomTargetCounter %
                enemyList[index]['target_count_to_throw_trash'] ==
            0) {
          trashAddedToGame.add(
              Trash(position, gameScreen, enemyList[index]['mixed_trash']));
          updateDrawingOrder();
        }
        randomTargetPosition();
      }
    }
  }

  void updateDrawingOrder() {
    gameScreen.addAll(trashAddedToGame);
    gameScreen.addAll(addList);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is! Trash && other is! Powers) {
      final displacement = position - other.position;
      final scaledDisplacement = displacement.normalized() * 3.5;
      position += scaledDisplacement;
      if (other is! Player) {
        randomTargetPosition();
      }
    } else if (other is Powers && enemyList[index]['steals']) {
      FlameAudio.play('enemy_eat.wav');
      int indexToRemove =
          trashAddedToGame.indexWhere((component) => component == other);
      if (indexToRemove != -1) {
        trashAddedToGame.removeAt(indexToRemove);
      }
      if(other.type == 'destroy_enemy'){
        powerList[powerList
            .indexWhere((element) => element['type'] == 'destroy_enemy')]
        ['isAdded'] = false;
      }
      gameScreen.remove(other);
    }
  }
}

import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame_audio/flame_audio.dart';
import 'package:shady_recycle/components/bag.dart';
import 'package:shady_recycle/components/enemy.dart';
import 'package:shady_recycle/components/powers.dart';
import 'package:shady_recycle/components/trash.dart';
import 'package:shady_recycle/components/trashcan.dart';
import 'dart:async';
import '../constants.dart';
import '../main.dart';
import '../screens/game_screen.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<ShadyRecycleGame> {
  Player({required this.joystick, required this.gameScreen})
      : super(anchor: Anchor.center);

  double playerSize = 40.0;
  final JoystickComponent joystick;
  final GameScreen gameScreen;
  late final Sprite idle;
  late final Sprite move1;
  late final Sprite move2;
  bool isMoving = false;

  late List<Sprite> moveSprites;
  int currentMoveSpriteIndex = 0;

  double spriteChangeDelay = 0.1;
  double timeSinceLastSpriteChange = 0.0;
  double speed = 100.0;
  int enemyDestroyDelay = 10;
  int speedDelay = 10;

  void sizeAdjustment() {
    height = sprite!.srcSize.y * (playerSize / sprite!.srcSize.x);
    width = playerSize;
  }

  @override
  Future<void> onLoad() async {
    idle = await gameRef.loadSprite('player/shady_idle.png');
    move1 = await gameRef.loadSprite('player/shady_move_1.png');
    move2 = await gameRef.loadSprite('player/shady_move_2.png');

    sprite = idle;
    moveSprites = [move1, move2];
    sizeAdjustment();
    position = gameRef.size / 2;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    const double minX = 0;
    final double maxX = gameRef.size.x;
    const double minY = 0;
    final double maxY = gameRef.size.y;

    if (joystick.direction != JoystickDirection.idle) {
      isMoving = true;
      sizeAdjustment();
      position.add(joystick.relativeDelta * speed * dt);
      angle = joystick.delta.screenAngle();

      if (position.x < minX) {
        position.x = maxX;
      } else if (position.x > maxX) {
        position.x = minX;
      }
      if (position.y < minY) {
        position.y = maxY;
      } else if (position.y > maxY) {
        position.y = minY;
      }

      timeSinceLastSpriteChange += dt;

      if (timeSinceLastSpriteChange >= spriteChangeDelay) {
        currentMoveSpriteIndex =
            (currentMoveSpriteIndex + 1) % moveSprites.length;
        sprite = moveSprites[currentMoveSpriteIndex];

        timeSinceLastSpriteChange = 0.0;
      }

      if (position.x < minX) {
        position.x = maxX;
      } else if (position.x > maxX) {
        position.x = minX;
      }
    } else {
      isMoving = false;
      sizeAdjustment();
      sprite = idle;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Trash &&
        !other.addedToPollutionList &&
        trashBagList.length < Bag().maxItemsInBag &&
        isPickingTrash) {
      FlameAudio.play('pick_trash.wav', volume: 0.5);
      int indexToRemove =
          trashAddedToGame.indexWhere((component) => component == other);
      if (indexToRemove != -1) {
        trashAddedToGame.removeAt(indexToRemove);
      }
      gameScreen.remove(other);
      trashBagList.add({'trash': other, 'sprite': other.sprite!});
    } else if (other is Powers &&
        isPickingTrash) {
      int indexToRemove =
          trashAddedToGame.indexWhere((component) => component == other);
      if (indexToRemove != -1) {
        trashAddedToGame.removeAt(indexToRemove);
      }
      if (other.type == 'faster') {
        FlameAudio.play('faster.wav');
        speed = 200;
        Timer(Duration(seconds: speedDelay), () {
          speed = 100;
        });
      } else if (other.type == 'empty_bag') {
        FlameAudio.play('empty_bag.wav');
        trashBagList.removeWhere((item) {
          if (item['trash'] is Trash) {
            updateScore += 1;
            return true;
          } else {
            return false;
          }
        });
      } else if (other.type == 'destroy_enemy') {
        FlameAudio.play('enemy_destroy.wav');
        gameScreen.isEnemyDestroyMode = true;
        gameScreen.removeWhere((item) {
          if (item is Enemy) {
            item.enemyBeingDestroyed = true;
            Timer(const Duration(seconds: 2), () {
              gameScreen.remove(item);
            });
            return false;
          }
          return false;
        });
        gameScreen.addComponentList.removeWhere((item) {
          if (item is Enemy) {
            return true;
          }
          return false;
        });
        Timer(Duration(seconds: enemyDestroyDelay), () {
          for (int i = 0; i < gameScreen.enemiesAdded; i++) {
            gameScreen.addComponentList.add(Enemy(
                enemyList: enemyList,
                index: i,
                gameScreen: gameScreen,
                addList: gameScreen.addComponentList));
            enemyList[i]['isAdded'] = true;
          }
          gameScreen.addAll(gameScreen.addComponentList);
          gameScreen.isEnemyDestroyMode = false;
        });
        powerList[powerList
            .indexWhere((element) => element['type'] == 'destroy_enemy')]
        ['isAdded'] = false;
      } else if (other.type == 're_nature') {
        FlameAudio.play('re_nature.wav');
        gameScreen.removeWhere((item) {
          if (item is Trash &&
              item.trashSize >= toPollutionConvertLimitSize) {
            item.isReNaturePicked = true;
            Timer(const Duration(seconds: 1), () {
              gameScreen.remove(item);
            });
            return false;
          } else {
            return false;
          }
        });
        pollutionList.clear();
        trashAddedToGame.clear();
      }
      gameScreen.remove(other);
    } else if (other is! Trash && other is! Powers) {
      final displacement = position - other.position;
      final scaledDisplacement = displacement.normalized() * 3.5;
      position += scaledDisplacement;
      if (trashBagList.isNotEmpty) {
        if (other is Trashcan &&
            other.trashcanType == trashBagList.last['trash'].type) {
          FlameAudio.play('trash_trashcan.wav', volume: 0.3);
          trashBagList.removeLast();
          updateScore += 1;
        }
      }
    }
  }
}

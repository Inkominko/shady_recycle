import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../constants.dart';
import '../main.dart';
import '../screens/game_screen.dart';

class Trash extends SpriteComponent
    with HasGameRef<ShadyRecycleGame>, CollisionCallbacks {
  Trash(this.trashPosition, this.gameScreen, this.mixedTrash)
      : super(anchor: Anchor.center);
  double trashSize = 5.0;
  double trashPollutionSpeed = 0.01;

  Vector2 trashPosition;
  bool isInBag = false;
  String trashColor = '';
  String trashCanColor = '';
  String type = '';
  GameScreen gameScreen;
  bool mixedTrash;
  bool addedToPollutionList = false;
  bool isReNaturePicked = false;

  void sizeAdjustment() {
    height = sprite!.srcSize.y * (trashSize / sprite!.srcSize.x);
    width = trashSize;
  }

  void removeItemFromTrashAddedToGame() {
    int indexToRemove =
        trashAddedToGame.indexWhere((component) => component == this);
    if (indexToRemove != -1) {
      trashAddedToGame.removeAt(indexToRemove);
    }
  }

  @override
  Future<void> onLoad() async {
    if (mixedTrash) {
      Random randomBG = Random();
      int randomBGIndex = randomBG.nextInt(trashList.length);

      type = trashList[randomBGIndex]['type'];
      sprite = await gameRef.loadSprite(trashList[randomBGIndex]['path']);
    } else {
      List<dynamic> filteredList = trashList
          .where((item) => item['trashcan_color'] == item['color'])
          .toList();

      Random randomFiltered = Random();
      int randomFilteredIndex = randomFiltered.nextInt(filteredList.length);

      type = filteredList[randomFilteredIndex]['type'];
      sprite =
          await gameRef.loadSprite(filteredList[randomFilteredIndex]['path']);
    }

    sizeAdjustment();
    position = trashPosition;
    add(RectangleHitbox());
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if(isReNaturePicked){
      trashSize -= 1;
    }
    if(trashSize <= pollutionStopLimitSize){
      trashSize += trashPollutionSpeed;
    }
    if (trashSize >= toPollutionConvertLimitSize && !addedToPollutionList) {
      FlameAudio.play('trash_pollution.wav', volume: 0.3);
      removeItemFromTrashAddedToGame();
      sprite = await gameRef.loadSprite('trashcans/pollution.png');
      pollutionList.add(this);
      addedToPollutionList = true;
    }
    sizeAdjustment();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Trash && addedToPollutionList) {
      final displacement = position - other.position;
      final scaledDisplacement = displacement.normalized() * 3.5;
      position += scaledDisplacement;
    }
  }
}

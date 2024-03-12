import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shady_recycle/components/ui/pause_button.dart';
import 'package:shady_recycle/components/ui/score.dart';
import '../components/bag.dart';
import '../components/enemy.dart';
import '../components/trash.dart';
import '../components/ui/joystick.dart';
import '../components/ui/pick_switch.dart';
import '../components/player.dart';
import '../components/powers.dart';
import '../components/trashcan.dart';
import '../constants.dart';
import '../main.dart';

class GameScreen extends Component
    with
        HasGameRef<ShadyRecycleGame>,
        HasCollisionDetection,
        CollisionCallbacks {
  Player? player;
  Joystick? joystick;
  Bag? bag;
  Score? score;
  SwitchPick? switchPicking;
  Pause? pauseButton;

  List<Component> addComponentList = [];
  List<Component> addUiList = [];
  bool uiComponentsAdded = false;

  int enemiesAdded = 0;
  int enemyIndex = 0;
  bool isEnemyDestroyMode = false;

  void addingEnemies() {
    if (enemyList[enemyIndex]['score_to_add'] <= updateScore &&
        !enemyList[enemyIndex]['isAdded']) {
      addComponentList.add(Enemy(
          enemyList: enemyList,
          index: enemyIndex,
          gameScreen: this,
          addList: addComponentList));
      enemyList[enemyIndex]['isAdded'] = true;
      enemiesAdded += 1;
      if (enemyIndex < enemyList.length - 1) {
        enemyIndex += 1;
      }
    }
  }

  void addingPowers() {
    if (updateScore % powerAddedScore != 0) {
      addedPower = false;
    } else if (updateScore > 0 &&
        updateScore % powerAddedScore == 0 &&
        addedPower == false) {
      addedPower = true;
      Timer(const Duration(seconds: 2), () {
        trashAddedToGame.add(Powers());
      });
    }
  }

  Future  startGame() async {
    add(Background(Color(whiteColor)));
    addComponentList.add(player!);

    trashcanPositions.shuffle();

    for (int i = 0; i < trashcanList.length; i++) {
      addComponentList.add(Trashcan(
          trashcanPath: trashcanList[i]['path'],
          trashcanType: trashcanList[i]['type'],
          position: trashcanPositions[i]));
    }

    addingEnemies();

    addAll(addComponentList);

    addUiList.add(joystick!.joystickComponent);
    addUiList.add(bag!);
    addUiList.add(score!);
    addUiList.add(switchPicking!);
    addUiList.add(pauseButton!);
    gameRef.camera.viewport.addAll(addUiList);
    uiComponentsAdded = true;
  }

  void gameOverClear() {
    isGameOver = true;
    gameRef.camera.viewport.removeAll(addUiList);
    removeAll(addComponentList);
    removeAll(trashAddedToGame);
    removeAll(pollutionList);
    addUiList.clear();
    addComponentList.clear();
    trashBagList.clear();
    trashAddedToGame.clear();
    pollutionList.clear();
    isPickingTrash = true;
    updateScore = 0;
    addedPower = false;
    uiComponentsAdded = false;
    enemiesAdded = 0;
    enemyIndex = 0;
    isEnemyDestroyMode = false;
    joystick = null;
    player = null;
    bag = null;
    score = null;
    switchPicking = null;
    pauseButton = null;
    for (int i = 0; i < enemyList.length; i++) {
      enemyList[i]['isAdded'] = false;
    }
    for (int i = 0; i < powerList.length; i++) {
      powerList[i]['isAdded'] = false;
    }
  }

  @override
  void onMount() {
    FlameAudio.bgm.play('recycle_play_music.mp3');
    joystick = Joystick(gameRef);
    player = Player(joystick: joystick!.joystickComponent, gameScreen: this);
    bag = Bag();
    score = Score(gameScreen: this);
    switchPicking = SwitchPick();
    pauseButton = Pause(gameScreen: this);
    startGame();
  }

  @override
  void update(double dt) {
    if(!isGameOver){
      addingPowers();
      if (!isEnemyDestroyMode) {
        addingEnemies();
      }
      if (!uiComponentsAdded) {
        gameRef.camera.viewport.addAll(addUiList);
        uiComponentsAdded = true;
      }

      double totalPollutedSurfaceArea = 0;
      for (int i = 0; i < pollutionList.length; i++) {
        if (pollutionList[i] is Trash) {
          Trash trash = pollutionList[i] as Trash;
          num surfaceArea = pi * pow(trash.trashSize / 2, 2);
          totalPollutedSurfaceArea += surfaceArea;
        }
      }
      if (totalPollutedSurfaceArea >= screenSurface!) {
        gameOverClear();
        game.router.pushNamed('game_over');
      }
      super.update(dt);
    }
  }
}

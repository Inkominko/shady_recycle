import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../constants.dart';
import '../../main.dart';

class MusicButton extends SpriteButtonComponent
    with HasGameRef<ShadyRecycleGame> {
  double offSet = 10;

  @override
  void onLoad() async {
    Sprite music = await gameRef.loadSprite('ui/music_on.png');
    Sprite noMusic = await gameRef.loadSprite('ui/music_off.png');

    if(isMusic){
      button = music;
    }else{
      button = noMusic;
    }

    size = vectorHeightSizeAdjustment(40, button);
    position = Vector2(3.5 * size.x + offSet, scaledSize.y / 2 + offSet);
    anchor = Anchor.center;

    onPressed = () async {
      if (!isExitDialogShown && !isHelpDialogShown) {
        FlameAudio.play('tap.wav', volume: 0.3);
        isMusic = !isMusic;
        gameRef.resumeEngine();
        if (isMusic) {
          button = music;
          FlameAudio.bgm.play('recycle_play_music.mp3');
        } else {
          button = noMusic;
          FlameAudio.bgm.stop();
        }
        Timer(const Duration(milliseconds: 100), () {
          gameRef.pauseEngine();
        });
      }
    };
  }
}
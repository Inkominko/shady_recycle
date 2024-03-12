import 'package:flame/components.dart';
import 'package:flutter/material.dart';

double? screenHeight;
double? screenWidth;
double? screenSurface;

void getScreenSize() {
  final double physicalHeight = WidgetsBinding
      .instance.platformDispatcher.views.first.physicalSize.height;
  final double physicalWidth =
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
  final double devicePixelRatio =
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  screenHeight = physicalHeight / devicePixelRatio;
  screenWidth = physicalWidth / devicePixelRatio;
  screenSurface = screenHeight! * screenWidth!;
}

bool isGameOver = false;
bool isPaused = false;
bool isMusic = true;
bool isExitDialogShown = false;
bool isHelpDialogShown = false;

int blackColor = 0xff000000;
int whiteColor = 0xffffffff;

class Background extends Component {
  Background(this.color);
  final Color color;

  @override
  void render(Canvas canvas) {
    canvas.drawColor(color, BlendMode.srcATop);
  }
}

Vector2 vectorHeightSizeAdjustment(double width, Sprite sourceSprite) {
  return Vector2(
      width, sourceSprite.srcSize.y * (width / sourceSprite.srcSize.x));
}

Vector2 vectorWidthSizeAdjustment(double height, Sprite sourceSprite) {
  return Vector2(
      sourceSprite.srcSize.x * (height / sourceSprite.srcSize.y), height);
}

List<dynamic> trashBagList = [];
List<Component> trashAddedToGame = [];
List<Component> pollutionList = [];
double toPollutionConvertLimitSize = 30.0;
double pollutionStopLimitSize = 60.0;
bool isPickingTrash = true;
List<dynamic> trashList = [
  {
    'path': 'trash/glass_blue.png',
    'type': 'glass',
    'color': 'blue',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/envelope_blue.png',
    'type': 'paper',
    'color': 'blue',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/clip_purple.png',
    'type': 'metal',
    'color': 'purple',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/glass_orange.png',
    'type': 'glass',
    'color': 'orange',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/iron_purple.png',
    'type': 'metal',
    'color': 'purple',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/lettuce_orange.png',
    'type': 'organic',
    'color': 'orange',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/envelope_orange.png',
    'type': 'paper',
    'color': 'orange',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/glass_bottle_red.png',
    'type': 'glass',
    'color': 'red',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/plastic_bottle_purple.png',
    'type': 'plastic',
    'color': 'purple',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/jar_orange.png',
    'type': 'glass',
    'color': 'orange',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/beer_glass_purple.png',
    'type': 'glass',
    'color': 'purple',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/scissors_blue.png',
    'type': 'metal',
    'color': 'blue',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/envelope_green.png',
    'type': 'paper',
    'color': 'green',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/beer_glass_blue.png',
    'type': 'glass',
    'color': 'blue',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/egg_orange.png',
    'type': 'organic',
    'color': 'orange',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/jar_red.png',
    'type': 'glass',
    'color': 'red',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/box_orange.png',
    'type': 'paper',
    'color': 'orange',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/phone_red.png',
    'type': 'e-waste',
    'color': 'red',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/glass_bottle_purple.png',
    'type': 'glass',
    'color': 'purple',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/lettuce_red.png',
    'type': 'organic',
    'color': 'red',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/phone_yellow.png',
    'type': 'e-waste',
    'color': 'yellow',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/paper_yellow.png',
    'type': 'paper',
    'color': 'yellow',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/glass_bottle_green.png',
    'type': 'glass',
    'color': 'green',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/blender_purple.png',
    'type': 'e-waste',
    'color': 'purple',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/tv_purple.png',
    'type': 'e-waste',
    'color': 'purple',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/cup_orange.png',
    'type': 'plastic',
    'color': 'orange',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/glass_red.png',
    'type': 'glass',
    'color': 'red',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/bag_purple.png',
    'type': 'plastic',
    'color': 'purple',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/newspaper_blue.png',
    'type': 'paper',
    'color': 'blue',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/blender_red.png',
    'type': 'e-waste',
    'color': 'red',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/apple_yellow.png',
    'type': 'organic',
    'color': 'yellow',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/tv_red.png',
    'type': 'e-waste',
    'color': 'red',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/can_yellow.png',
    'type': 'metal',
    'color': 'yellow',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/paprika_red.png',
    'type': 'organic',
    'color': 'red',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/beer_glass_red.png',
    'type': 'glass',
    'color': 'red',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/plastic_bottle_red.png',
    'type': 'plastic',
    'color': 'red',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/paprika_orange.png',
    'type': 'organic',
    'color': 'orange',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/scissors_yellow.png',
    'type': 'metal',
    'color': 'yellow',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/paprika_purple.png',
    'type': 'organic',
    'color': 'purple',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/jar_green.png',
    'type': 'glass',
    'color': 'green',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/paprika_green.png',
    'type': 'organic',
    'color': 'green',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/newspaper_yellow.png',
    'type': 'paper',
    'color': 'yellow',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/box_blue.png',
    'type': 'paper',
    'color': 'blue',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/drink_can_yellow.png',
    'type': 'metal',
    'color': 'yellow',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/bag_orange.png',
    'type': 'plastic',
    'color': 'orange',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/cup_purple.png',
    'type': 'plastic',
    'color': 'purple',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/blender_orange.png',
    'type': 'e-waste',
    'color': 'orange',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/tv_orange.png',
    'type': 'e-waste',
    'color': 'orange',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/container_yellow.png',
    'type': 'plastic',
    'color': 'yellow',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/glass_green.png',
    'type': 'glass',
    'color': 'green',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/scissors_green.png',
    'type': 'metal',
    'color': 'green',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/glass_bottle_orange.png',
    'type': 'glass',
    'color': 'orange',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/envelope_red.png',
    'type': 'paper',
    'color': 'red',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/box_purple.png',
    'type': 'paper',
    'color': 'purple',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/egg_purple.png',
    'type': 'organic',
    'color': 'purple',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/newspaper_red.png',
    'type': 'paper',
    'color': 'red',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/drink_can_blue.png',
    'type': 'metal',
    'color': 'blue',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/box_red.png',
    'type': 'paper',
    'color': 'red',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/box_green.png',
    'type': 'paper',
    'color': 'green',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/beer_glass_orange.png',
    'type': 'glass',
    'color': 'orange',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/jar_purple.png',
    'type': 'glass',
    'color': 'purple',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/envelope_purple.png',
    'type': 'paper',
    'color': 'purple',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/lettuce_purple.png',
    'type': 'organic',
    'color': 'purple',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/drink_can_green.png',
    'type': 'metal',
    'color': 'green',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/drink_can_red.png',
    'type': 'metal',
    'color': 'red',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/plastic_bottle_green.png',
    'type': 'plastic',
    'color': 'green',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/iron_orange.png',
    'type': 'metal',
    'color': 'orange',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/glass_purple.png',
    'type': 'glass',
    'color': 'purple',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/clip_orange.png',
    'type': 'metal',
    'color': 'orange',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/paper_blue.png',
    'type': 'paper',
    'color': 'blue',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/lettuce_green.png',
    'type': 'organic',
    'color': 'green',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/can_purple.png',
    'type': 'metal',
    'color': 'purple',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/container_red.png',
    'type': 'plastic',
    'color': 'red',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/apple_purple.png',
    'type': 'organic',
    'color': 'purple',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/container_green.png',
    'type': 'plastic',
    'color': 'green',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/newspaper_orange.png',
    'type': 'paper',
    'color': 'orange',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/plastic_bottle_orange.png',
    'type': 'plastic',
    'color': 'orange',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/paper_green.png',
    'type': 'paper',
    'color': 'green',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/newspaper_green.png',
    'type': 'paper',
    'color': 'green',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/drink_can_orange.png',
    'type': 'metal',
    'color': 'orange',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/bag_yellow.png',
    'type': 'plastic',
    'color': 'yellow',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/tv_yellow.png',
    'type': 'e-waste',
    'color': 'yellow',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/phone_green.png',
    'type': 'e-waste',
    'color': 'green',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/blender_yellow.png',
    'type': 'e-waste',
    'color': 'yellow',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/iron_red.png',
    'type': 'metal',
    'color': 'red',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/iron_green.png',
    'type': 'metal',
    'color': 'green',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/container_orange.png',
    'type': 'plastic',
    'color': 'orange',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/blender_green.png',
    'type': 'e-waste',
    'color': 'green',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/phone_purple.png',
    'type': 'e-waste',
    'color': 'purple',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/paper_purple.png',
    'type': 'paper',
    'color': 'purple',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/paper_red.png',
    'type': 'paper',
    'color': 'red',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/phone_blue.png',
    'type': 'e-waste',
    'color': 'blue',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/jar_blue.png',
    'type': 'glass',
    'color': 'blue',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/glass_bottle_yellow.png',
    'type': 'glass',
    'color': 'yellow',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/beer_glass_green.png',
    'type': 'glass',
    'color': 'green',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/bag_blue.png',
    'type': 'plastic',
    'color': 'blue',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/can_blue.png',
    'type': 'metal',
    'color': 'blue',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/beer_glass_yellow.png',
    'type': 'glass',
    'color': 'yellow',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/plastic_bottle_yellow.png',
    'type': 'plastic',
    'color': 'yellow',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/tv_green.png',
    'type': 'e-waste',
    'color': 'green',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/clip_green.png',
    'type': 'metal',
    'color': 'green',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/clip_blue.png',
    'type': 'metal',
    'color': 'blue',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/can_red.png',
    'type': 'metal',
    'color': 'red',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/clip_yellow.png',
    'type': 'metal',
    'color': 'yellow',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/iron_yellow.png',
    'type': 'metal',
    'color': 'yellow',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/cup_green.png',
    'type': 'plastic',
    'color': 'green',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/plastic_bottle_blue.png',
    'type': 'plastic',
    'color': 'blue',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/glass_yellow.png',
    'type': 'glass',
    'color': 'yellow',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/container_blue.png',
    'type': 'plastic',
    'color': 'blue',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/envelope_yellow.png',
    'type': 'paper',
    'color': 'yellow',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/lettuce_yellow.png',
    'type': 'organic',
    'color': 'yellow',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/egg_green.png',
    'type': 'organic',
    'color': 'green',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/iron_blue.png',
    'type': 'metal',
    'color': 'blue',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/lettuce_blue.png',
    'type': 'organic',
    'color': 'blue',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/jar_yellow.png',
    'type': 'glass',
    'color': 'yellow',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/apple_green.png',
    'type': 'organic',
    'color': 'green',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/clip_red.png',
    'type': 'metal',
    'color': 'red',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/glass_bottle_blue.png',
    'type': 'glass',
    'color': 'blue',
    'trashcan_color': 'green'
  },
  {
    'path': 'trash/cup_blue.png',
    'type': 'plastic',
    'color': 'blue',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/egg_yellow.png',
    'type': 'organic',
    'color': 'yellow',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/tv_blue.png',
    'type': 'e-waste',
    'color': 'blue',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/box_yellow.png',
    'type': 'paper',
    'color': 'yellow',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/blender_blue.png',
    'type': 'e-waste',
    'color': 'blue',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/paprika_blue.png',
    'type': 'organic',
    'color': 'blue',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/cup_red.png',
    'type': 'plastic',
    'color': 'red',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/bag_green.png',
    'type': 'plastic',
    'color': 'green',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/apple_red.png',
    'type': 'organic',
    'color': 'red',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/paper_orange.png',
    'type': 'paper',
    'color': 'orange',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/phone_orange.png',
    'type': 'e-waste',
    'color': 'orange',
    'trashcan_color': 'red'
  },
  {
    'path': 'trash/apple_blue.png',
    'type': 'organic',
    'color': 'blue',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/scissors_red.png',
    'type': 'metal',
    'color': 'red',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/egg_red.png',
    'type': 'organic',
    'color': 'red',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/container_purple.png',
    'type': 'plastic',
    'color': 'purple',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/can_green.png',
    'type': 'metal',
    'color': 'green',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/bag_red.png',
    'type': 'plastic',
    'color': 'red',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/cup_yellow.png',
    'type': 'plastic',
    'color': 'yellow',
    'trashcan_color': 'orange'
  },
  {
    'path': 'trash/drink_can_purple.png',
    'type': 'metal',
    'color': 'purple',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/newspaper_purple.png',
    'type': 'paper',
    'color': 'purple',
    'trashcan_color': 'blue'
  },
  {
    'path': 'trash/egg_blue.png',
    'type': 'organic',
    'color': 'blue',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/can_orange.png',
    'type': 'metal',
    'color': 'orange',
    'trashcan_color': 'yellow'
  },
  {
    'path': 'trash/apple_orange.png',
    'type': 'organic',
    'color': 'orange',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/paprika_yellow.png',
    'type': 'organic',
    'color': 'yellow',
    'trashcan_color': 'purple'
  },
  {
    'path': 'trash/scissors_purple.png',
    'type': 'metal',
    'color': 'purple',
    'trashcan_color': 'yellow'
  }
];

double trashcanSize = 40.0;
List<dynamic> trashcanList = [
  {'path': 'trashcans/e_waste_trash.png', 'type': 'e-waste'},
  {'path': 'trashcans/glass_trash.png', 'type': 'glass'},
  {'path': 'trashcans/metal_trash.png', 'type': 'metal'},
  {'path': 'trashcans/organic_trash.png', 'type': 'organic'},
  {'path': 'trashcans/paper_trash.png', 'type': 'paper'},
  {'path': 'trashcans/plastic_trash.png', 'type': 'plastic'}
];

List<Vector2> trashcanPositions = [
  Vector2(screenWidth! / 4 + trashcanSize / 2,
          screenHeight! / 4 + trashcanSize / 2) -
      Vector2.all(trashcanSize / 2),
  Vector2(screenWidth! / 4 * 2 + trashcanSize / 2,
          screenHeight! / 4 + trashcanSize / 2) -
      Vector2.all(trashcanSize / 2),
  Vector2(screenWidth! / 4 * 3 + trashcanSize / 2,
          screenHeight! / 4 + trashcanSize / 2) -
      Vector2.all(trashcanSize / 2),
  Vector2(screenWidth! / 4 + trashcanSize / 2,
          screenHeight! / 4 * 3 + trashcanSize / 2) -
      Vector2.all(trashcanSize / 2),
  Vector2(screenWidth! / 4 * 2 + trashcanSize / 2,
          screenHeight! / 4 * 3 + trashcanSize / 2) -
      Vector2.all(trashcanSize / 2),
  Vector2(screenWidth! / 4 * 3 + trashcanSize / 2,
          screenHeight! / 4 * 3 + trashcanSize / 2) -
      Vector2.all(trashcanSize / 2)
];

List<dynamic> enemyList = [
  {
    'move1': 'enemies/red_1.png',
    'move2': 'enemies/red_2.png',
    'cloud': 'enemies/red_cloud.png',
    'speed': 50.0,
    'size': 40.0,
    'steals': false,
    'type': 'e-waste',
    'color': 'red',
    'score_to_add': 0,
    'isAdded': false,
    'mixed_trash': false,
    'target_count_to_throw_trash': 1
  },
  {
    'move1': 'enemies/orange_1.png',
    'move2': 'enemies/orange_2.png',
    'cloud': 'enemies/orange_cloud.png',
    'speed': 30.0,
    'size': 40.0,
    'steals': false,
    'type': 'plastic',
    'color': 'orange',
    'score_to_add': 5,
    'isAdded': false,
    'mixed_trash': false,
    'target_count_to_throw_trash': 1
  },
  {
    'move1': 'enemies/yellow_1.png',
    'move2': 'enemies/yellow_2.png',
    'cloud': 'enemies/yellow_cloud.png',
    'speed': 120.0,
    'size': 30.0,
    'steals': false,
    'type': 'metal',
    'color': 'yellow',
    'score_to_add': 10,
    'isAdded': false,
    'mixed_trash': false,
    'target_count_to_throw_trash': 3
  },
  {
    'move1': 'enemies/green_1.png',
    'move2': 'enemies/green_2.png',
    'cloud': 'enemies/green_cloud.png',
    'speed': 50.0,
    'size': 40.0,
    'steals': true,
    'type': 'glass',
    'color': 'green',
    'score_to_add': 20,
    'isAdded': false,
    'mixed_trash': true,
    'target_count_to_throw_trash': 3
  },
  {
    'move1': 'enemies/blue_1.png',
    'move2': 'enemies/blue_2.png',
    'cloud': 'enemies/blue_cloud.png',
    'speed': 50.0,
    'size': 60.0,
    'steals': false,
    'type': 'paper',
    'color': 'blue',
    'score_to_add': 30,
    'isAdded': false,
    'mixed_trash': true,
    'target_count_to_throw_trash': 1
  },
  {
    'move1': 'enemies/purple_1.png',
    'move2': 'enemies/purple_2.png',
    'cloud': 'enemies/purple_cloud.png',
    'speed': 100.0,
    'size': 50.0,
    'steals': true,
    'type': 'organic',
    'color': 'purple',
    'score_to_add': 50,
    'isAdded': false,
    'mixed_trash': true,
    'target_count_to_throw_trash': 2
  }
];

int updateScore = 0;
bool addedPower = false;
int powerAddedScore = 5;
double powerSize = 25.0;
List<dynamic> powerList = [
 {'path': 'powers/faster.png', 'type': 'faster', 'isAdded': false},
  {'path': 'powers/empty_bag.png', 'type': 'empty_bag', 'isAdded': false},
  {
    'path': 'powers/destroy_enemy.png',
    'type': 'destroy_enemy',
    'isAdded': false
  },
  {'path': 'powers/re_nature.png', 'type': 're_nature', 'isAdded': false},
];
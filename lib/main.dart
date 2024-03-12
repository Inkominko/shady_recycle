import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:shady_recycle/screens/game_over_screen.dart';
import 'package:shady_recycle/screens/game_screen.dart';
import 'package:shady_recycle/screens/home_screen.dart';
import 'package:shady_recycle/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    runApp(GameWidget(game: ShadyRecycleGame()));
  });
}

class ShadyRecycleGame extends FlameGame{
  late final RouterComponent router;

  @override
  void onLoad() async{
    add(
      router = RouterComponent(
        routes: {
          'splash_screen': Route(SplashScreen.new),
          'home_screen': Route(HomeScreen.new),
          'game_screen': Route(GameScreen.new),
          'game_over': Route(GameOver.new)
        },
        initialRoute: 'splash_screen',
      ),
    );
  }
}

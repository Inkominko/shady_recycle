import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shady_recycle/constants.dart';
import '../main.dart';

class Bag extends Component with HasGameRef<ShadyRecycleGame> {
  final int maxItemsInBag = 5;
  final double bagWidth = 42;
  double bagHeight = 0.0;
  final double bagStrokeWidth = 2.0;
  final double bagX = screenWidth! - 50;
  final double bagY = 10;

  double trashSize = 0.0;

  @override
  void render(Canvas canvas) {
    bagHeight = bagWidth * maxItemsInBag;
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = bagStrokeWidth;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bagX, bagY, bagWidth, bagHeight),
      Radius.circular(bagWidth),
    );
    canvas.drawRRect(rect, borderPaint);

    final bagBottom = bagY + bagHeight;
    trashSize = bagWidth - bagStrokeWidth;
    for (int i = 0; i < trashBagList.length; i++) {
      final trashY = bagBottom - ((i + 1) * bagWidth);

      trashBagList[i]['sprite']?.render(
        canvas,
        position: Vector2(bagX + 1, trashY + 1),
        size: Vector2(trashSize, trashSize),
      );
    }
  }
}

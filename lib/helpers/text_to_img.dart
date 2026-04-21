import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Future<ui.Image> imageFromString(String text) async{
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final size = Size(500,200);

  final paint = Paint()..color = Colors.deepOrange;
  canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)
    ),
    textDirection: TextDirection.ltr
  );

  textPainter.layout(maxWidth: size.width);

  final offset = Offset((size.width-textPainter.width)/2, (size.height-textPainter.height)/2);
  
  textPainter.paint(canvas, offset);

  final picture = recorder.endRecording();
  return await picture.toImage(size.width.toInt(), size.height.toInt());
}
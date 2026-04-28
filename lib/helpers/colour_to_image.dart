import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
/*https://api.flutter.dev/flutter/dart-ui/PictureRecorder-class.html*/

Future<ui.Image> colourToImage(Color color, int width, int height) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final paint = Paint()..color = color;

  canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);

  final picture = recorder.endRecording();
  return await picture.toImage(width, height);
}

Future<Uint8List> imageToUint8List(ui.Image image) async {
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}
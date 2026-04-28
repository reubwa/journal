
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

/*
* Maths used to convert Latitude and Longitude into Slippery Map Tilenames
*
* https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames
* https://help.openstreetmap.org/questions/2687/coordinates-to-pixels-based-on-zoom/
* https://alexwlchan.net/2025/static-maps/
* */

/*https://api.flutter.dev/flutter/dart-ui/PictureRecorder-class.html*/
/*https://api.flutter.dev/flutter/painting/TextPainter-class.html*/

Future<Uint8List> locToImg(int zoom, LatLong ll, Uint8List bytes) async {
  final n = pow(2, zoom);
  final xExact = n * ((ll.longitude + 180.0) / 360.0);
  final latRad = ll.latitude * pi / 180.0;
  final yExact = n * (1.0 - (log(tan(latRad) + 1.0 / cos(latRad)) / pi)) / 2.0;

  final pixelX = ((xExact - xExact.floor()) * 256.0);
  final pixelY = ((yExact - yExact.floor()) * 256.0);

  // Decode the tile image
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final uiImage = frame.image;

  // Set up a canvas to draw the map tile and the pin
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);

  canvas.drawImage(uiImage, ui.Offset.zero, ui.Paint());

  // Draw the location pin icon directly onto the map
  final iconPainter = TextPainter(textDirection: TextDirection.ltr);
  iconPainter.text = TextSpan(
    text: String.fromCharCode(Icons.location_on.codePoint),
    style: TextStyle(
      fontSize: 36.0,
      fontFamily: Icons.location_on.fontFamily,
      package: Icons.location_on.fontPackage,
      color: Colors.red,
    ),
  );
  iconPainter.layout();

  // Offset the pin so the bottom tip points directly at the precise location
  iconPainter.paint(canvas, ui.Offset(pixelX - 18.0, pixelY - 36.0));

  final drawnPicture = recorder.endRecording();
  final finalImage = await drawnPicture.toImage(256, 256);
  final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
  final finalBytes = byteData!.buffer.asUint8List();
  return finalBytes;
}
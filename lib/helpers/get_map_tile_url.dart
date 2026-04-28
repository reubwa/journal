import 'dart:math';

String GetMapTileURL(double lat, double long, int zoom) {
  final n = pow(2, zoom);
  final x = (n * ((long + 180.0) / 360.0)).floor();
  final latRad = lat * pi / 180.0;
  final y = (n * (1.0 - (log(tan(latRad) + 1.0 / cos(latRad)) / pi)) / 2.0).floor();

  return 'https://tile.openstreetmap.org/$zoom/$x/$y.png';
}
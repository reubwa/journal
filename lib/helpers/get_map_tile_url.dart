import 'dart:math';

/*
* Maths used to convert Latitude and Longitude into Slippery Map Tilenames
*
* https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames
* https://help.openstreetmap.org/questions/2687/coordinates-to-pixels-based-on-zoom/
* https://alexwlchan.net/2025/static-maps/
* */

String GetMapTileURL(double lat, double long, int zoom) {
  final n = pow(2, zoom);
  final x = (n * ((long + 180.0) / 360.0)).floor();
  final latRad = lat * pi / 180.0;
  final y = (n * (1.0 - (log(tan(latRad) + 1.0 / cos(latRad)) / pi)) / 2.0).floor();

  return 'https://tile.openstreetmap.org/$zoom/$x/$y.png';
}
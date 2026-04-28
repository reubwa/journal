import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

LatLong llStringToFloatPair(String llString){
  final RegExp regExp = RegExp(r"[-+]?\d*\.?\d+");
  final Iterable<RegExpMatch> matches = regExp.allMatches(llString);
  var lat = 0.00;
  var lon = 0.00;
  if(matches.length >= 2){
    lat = double.parse(matches.elementAt(0).group(0)!);
    lon = double.parse(matches.elementAt(1).group(0)!);
  }
  return LatLong(lat, lon);
}
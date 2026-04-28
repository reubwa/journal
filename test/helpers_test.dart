import 'package:flutter_test/flutter_test.dart';
import 'package:journalapp/helpers/get_map_tile_url.dart';
import 'package:journalapp/helpers/ll_string_to_float_pair.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
/*https://docs.flutter.dev/cookbook/testing/unit/introduction*/
void main(){
  group('helpers', () {
    test('map tile URL', () {
      expect(GetMapTileURL(53.572153, -1.784432, 14), "https://tile.openstreetmap.org/14/8110/5293.png");
    });
    test('string to latlong type', (){
      expect(llStringToFloatPair("LatLong(53.572153, -1.784432)"), LatLong(53.572153, -1.784432));
    });
  });
}
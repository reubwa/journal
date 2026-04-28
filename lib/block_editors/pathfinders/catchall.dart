import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:journalapp/pickers/colour_picker.dart';
import 'package:journalapp/pickers/health_picker.dart';
import 'package:journalapp/pickers/image_picker.dart';
import 'package:journalapp/pickers/loc_picker.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

import '../../database.dart';
import '../../helpers/colour_to_image.dart';
import '../../helpers/get_map_tile_url.dart';
import '../../helpers/ll_to_loc.dart';
import '../../helpers/text_to_img.dart';

class CatchallPathfinder extends StatefulWidget {
  final Block block;
  final DateTime dt;
  const CatchallPathfinder({super.key, required this.block, required this.dt});

  @override
  State<CatchallPathfinder> createState() => _CatchallPathfinderState();
}

class _CatchallPathfinderState extends State<CatchallPathfinder> {
  final database = AppDatabase();
  Future _imgDone(ip.XFile? file) async {
    if (file == null) return;
    final bytes = await file.readAsBytes();
    return(database.update(database.blocks)..where((fil)=>fil.id.equals(widget.block.id))).write(BlocksCompanion(image: Value(bytes)));
  }
  Future _colourDone(Color picked) async {
    final uiImage = await colourToImage(picked, 300, 300);
    final bytes = await imageToUint8List(uiImage);
    return(database.update(database.blocks)..where((fil)=>fil.id.equals(widget.block.id))).write(BlocksCompanion(txt: Value(picked.toARGB32().toString()),
        image: Value(bytes)));
  }
  Future _locDone(LatLong ll) async {
    const zoom = 14;
    final url = GetMapTileURL(ll.latitude, ll.longitude, zoom);

    // Fetch standard OSM tile directly from the official network
    final request = await HttpClient().getUrl(Uri.parse(url));

    // Official OSM usage policy requires a valid User-Agent
    request.headers.add('User-Agent', 'JournalApp/1.0');
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);

    if (response.statusCode != 200) {
      throw Exception('Failed to load standard map tile (HTTP ${response.statusCode}):\n${String.fromCharCodes(bytes)}');
    }

    // Calculate the exact floating-point pixel coordinates for the location pin on the 256x256 tile
    Uint8List finalBytes = await locToImg(zoom, ll, bytes);

    return(database.update(database.blocks)..where((fil)=>fil.id.equals(widget.block.id))).write(BlocksCompanion(txt: Value(ll.toString()), image: Value(finalBytes)));
  }
  Future _healthDone(HealthDataPoint h) async {
    final img = await imageToUint8List(await imageFromString(h.toString()));
    return(database.update(database.blocks)..where((fil)=>fil.id.equals(widget.block.id))).write(BlocksCompanion(txt:Value(h.toString()),image: Value(img)));
  }
  @override
  Widget build(BuildContext context) {
   if(widget.block.type == BlockTypes.location){
     return LocPicker(onLocPicked: _locDone);
   }else if(widget.block.type == BlockTypes.colouredblock){
     return ColourPicker(onColorPicked: _colourDone);
   }else if(widget.block.type == BlockTypes.fitnessdata){
     return HealthPicker(onPointPicked: _healthDone, dt: widget.dt);
   }else{
     return ImagePicker(onFilePicked: _imgDone);
   }
  }
}

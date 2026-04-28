import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:journalapp/helpers/colour_to_image.dart';
import 'package:journalapp/helpers/get_map_tile_url.dart';
import 'package:journalapp/helpers/text_to_img.dart';
import 'package:journalapp/pickers/colour_picker.dart';
import 'package:journalapp/pickers/drawing_area.dart';
import 'package:journalapp/pickers/health_picker.dart';
import 'package:journalapp/pickers/image_picker.dart';
import 'package:journalapp/pickers/loc_picker.dart';
import 'package:journalapp/pickers/ret_text.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

import '../database.dart';
import '../helpers/ll_to_loc.dart';

class AddBlock extends StatefulWidget {
  int entryId = 0;
  DateTime entryDate;
  AddBlock({super.key, required this.entryId, required this.entryDate});

  @override
  State<AddBlock> createState() => _AddBlockState();
}

class _AddBlockState extends State<AddBlock> {
  bool isComp = false;
  ImageProvider<Object>? chosenFile;
  final database = AppDatabase();

  Future handlePickedImage(ip.XFile? file) async {
    if (file == null) return;

    final bytes = await file.readAsBytes();

    await database.into(database.blocks).insert(BlocksCompanion(
        type: Value(BlockTypes.image),
        parentEntry: Value(widget.entryId),
        positionAmongstSiblings: Value(1),
        isHeader: Value(false),
        txt: Value(""),
        image: Value(bytes)
    ));

    setState(() {
      chosenFile = MemoryImage(bytes);
      isComp = true;
    });
  }

  Future handlePickedColour(Color picked) async {
    final uiImage = await colourToImage(picked, 300, 300);
    final bytes = await imageToUint8List(uiImage);

    await database.into(database.blocks).insert(BlocksCompanion(
        type: Value(BlockTypes.colouredblock),
        parentEntry: Value(widget.entryId),
        positionAmongstSiblings: Value(1),
        isHeader: Value(false),
        txt: Value(picked.toARGB32().toString()),
        image: Value(bytes)
    ));

    setState(() {
      chosenFile = MemoryImage(bytes);
      isComp = true;
    });
  }

  Future handlePickedText(String text) async {
    final img = await imageToUint8List(await imageFromString(text));
    await database.into(database.blocks).insert(BlocksCompanion(
        type: Value(BlockTypes.text),
        parentEntry: Value(widget.entryId),
        positionAmongstSiblings: Value(1),
        isHeader: Value(false),
        txt: Value(text),
        image: Value(img)
    ));

    setState(() {
      chosenFile = MemoryImage(img);
      isComp = true;
    });
  }

  Future handleFinishedDoodle(Uint8List imgBytes, String json) async{
    await database.into(database.blocks).insert(BlocksCompanion(
        type: Value(BlockTypes.doodle),
        parentEntry: Value(widget.entryId),
        positionAmongstSiblings: Value(1),
        isHeader: Value(false),
        txt: Value(json),
        image: Value(imgBytes)
    ));

    setState(() {
      chosenFile = MemoryImage(imgBytes);
      isComp = true;
    });
  }

  Future handleLocationPicked(LatLong ll) async {
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

    await database.into(database.blocks).insert(BlocksCompanion(
        type: Value(BlockTypes.location),
        parentEntry: Value(widget.entryId),
        positionAmongstSiblings: Value(1),
        isHeader: Value(false),
        txt: Value(ll.toString()),
        image: Value(finalBytes)
    ));

    setState(() {
      chosenFile = MemoryImage(finalBytes);
      isComp = true;
    });
  }


  Future handlePickedHealth(HealthDataPoint h) async{
    final img = await imageToUint8List(await imageFromString(h.toString()));
    await database.into(database.blocks).insert(BlocksCompanion(
        type: Value(BlockTypes.location),
        parentEntry: Value(widget.entryId),
        positionAmongstSiblings: Value(1),
        isHeader: Value(false),
        txt: Value(h.toString()),
        image: Value(img)
    ));
    setState(() {
      chosenFile = MemoryImage(img);
      isComp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add a Block"),
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close)),
          actions: [
            IconButton(onPressed: isComp ? (){
              Navigator.pop(context);
            } : null, icon: const Icon(Icons.check))
          ]
      ),
      body: Column(
          children: [
            chosenFile == null ? const ColoredBox(color: Colors.grey) : Image(image: chosenFile!, height: 300,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 8,
                children: [
                  FilledButton(onPressed: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ImagePicker(onFilePicked: handlePickedImage)));
                    });
                  }, child: const Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.image),
                        Text("Image")
                      ]
                  )),
                  FilledButton(onPressed: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ColourPicker(onColorPicked: handlePickedColour)));
                    });
                  }, child: const Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.color_lens),
                        Text("Solid Colour")
                      ]
                  )),
                  FilledButton(onPressed: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>RetText(onTextHanded: handlePickedText)));
                    });
                  }, child: const Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.text_snippet),
                        Text("Text")
                      ]
                  )),
                  FilledButton(onPressed: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DrawingArea(onDoodleFinished: handleFinishedDoodle)));
                    });
                  }, child: const Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.draw),
                        Text("Doodle")
                      ]
                  )),
                  FilledButton(onPressed: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>LocPicker(onLocPicked: handleLocationPicked)));
                    });
                  }, child: const Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.pin_drop),
                        Text("Location")
                      ]
                  )),
                  FilledButton(onPressed: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>HealthPicker(onPointPicked: handlePickedHealth, dt: widget.entryDate)));
                    });
                  }, child: const Row(
                      spacing: 8,
                      children: [
                        Icon(Icons.fitness_center),
                        Text("Fitness")
                      ]
                  ))
                ],
              ),
            )
          ]
      ),
    );
  }
}
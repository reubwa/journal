import 'dart:ui';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:journalapp/helpers/colour_to_image.dart';
import 'package:journalapp/helpers/text_to_img.dart';
import 'package:journalapp/pickers/colour_picker.dart';
import 'package:journalapp/pickers/drawing_area.dart';
import 'package:journalapp/pickers/image_picker.dart';
import 'package:journalapp/pickers/ret_text.dart';

import '../database.dart';

class AddHeader extends StatefulWidget {
  int entryId = 0;
  AddHeader({super.key, required this.entryId});

  @override
  State<AddHeader> createState() => _AddHeaderState();
}

class _AddHeaderState extends State<AddHeader> {
  bool isComp = false;
  ImageProvider<Object>? chosenFile;
  final database = AppDatabase();

  Future handlePickedImage(ip.XFile? file) async {
    if (file == null) return;

    final bytes = await file.readAsBytes();

    await database.into(database.blocks).insert(BlocksCompanion(
        type: Value(BlockTypes.image),
        parentEntry: Value(widget.entryId),
        positionAmongstSiblings: Value(0),
        isHeader: Value(true),
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
        positionAmongstSiblings: Value(0),
        isHeader: Value(true),
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
      positionAmongstSiblings: Value(0),
      isHeader: Value(true),
      txt: Value(text),
      image: Value(img)
    ));
    
    setState(() {
      chosenFile = MemoryImage(img);
      isComp = true;
    });
  }
  
  Future handleFinishedDoodle(Image img, String json) async{
    await database.into(database.blocks).insert(BlocksCompanion(
      type: Value(BlockTypes.doodle),
      parentEntry: Value(widget.entryId),
      positionAmongstSiblings: Value(0),
      isHeader: Value(true),
      txt: Value(json),
      image: Value(await imageToUint8List(img as ui.Image))
    ));

    setState(() async {
      chosenFile = MemoryImage(await imageToUint8List(img as ui.Image));
      isComp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Add a Header"),
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
          actions: [
            IconButton(onPressed: isComp ? (){
              Navigator.pop(context);
            } : null, icon: Icon(Icons.check))
          ]
      ),
      body: Column(
          children: [
            chosenFile == null ? ColoredBox(color: Colors.grey) : Image(image: chosenFile!, height: 300,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 8,
                children: [
                  FilledButton(onPressed: (){
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ImagePicker(onFilePicked: handlePickedImage)));
                    });
                  }, child: Row(
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
                  }, child: Row(
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
                  }, child: Row(
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
                  }, child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.draw),
                      Text("Doodle")
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
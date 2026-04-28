
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:journalapp/pickers/drawing_area.dart';
import 'package:journalapp/pickers/ret_text.dart';

import '../../database.dart';

class TextDoodlePathfinder extends StatefulWidget {
  final Block block;
  const TextDoodlePathfinder({super.key, required this.block});
  @override
  State<TextDoodlePathfinder> createState() => _TextDoodlePathfinderState();
}

class _TextDoodlePathfinderState extends State<TextDoodlePathfinder> {
  final database = AppDatabase();
  Future _textDone(String txt){
    return (database.update(database.blocks)..where((fil)=>fil.id.equals(widget.block.id))).write(BlocksCompanion(txt: Value(txt)));
  }
  Future _doodleDone(Uint8List imgBytes, String json){
    return (database.update(database.blocks)..where((fil)=>fil.id.equals(widget.block.id))).write(BlocksCompanion(txt: Value(json), image: Value(imgBytes)));
  }
  @override
  Widget build(BuildContext context) {
    if(widget.block.type == BlockTypes.text){
      return RetText(onTextHanded: _textDone, text: widget.block.txt);
    }else{
      return DrawingArea(onDoodleFinished: _doodleDone, drawingJSON: widget.block.txt);
    }
  }
}

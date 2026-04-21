import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class DrawingArea extends StatefulWidget {
  final Future Function(Image, String) onDoodleFinished;
  const DrawingArea({super.key, required this.onDoodleFinished});

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  final DrawingController _drawingController = DrawingController();
  bool isComp = false;
  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Doodle"),
        leading: IconButton(onPressed: ()=>{Navigator.pop(context)}, icon: Icon(Icons.close)),
        actions: [
          IconButton(onPressed: isComp ? () async {
            widget.onDoodleFinished(Image.memory(await _exportImage()), _exportJson());
            Navigator.pop(context);
          } : null, icon: Icon(Icons.check))
        ],
      ),
      body: Column(
        children: [
          // Drawing Board
          Expanded(
            child: DrawingBoard(
              controller: _drawingController,
              background: Container(color: Colors.white),
              onInteractionEnd: (_){
                setState(() {
                  isComp = _drawingController.canUndo();
                });
              },
            ),
          ),

          // Action Bar (slider, undo, redo, rotate, clear)
          DrawingBar(
            controller: _drawingController,
            tools: [
              DefaultActionItem.slider(),
              DefaultActionItem.undo(),
              DefaultActionItem.redo(),
              DefaultActionItem.turn(),
              DefaultActionItem.clear(),
            ],
          ),

          // Tool Bar (pen, brush, shapes, eraser)
          DrawingBar(
            controller: _drawingController,
            tools: [
              DefaultToolItem.pen(),
              DefaultToolItem.brush(),
              DefaultToolItem.rectangle(),
              DefaultToolItem.circle(),
              DefaultToolItem.straightLine(),
              DefaultToolItem.eraser(),
            ],
          ),
        ],
      )
    );
  }

  Future<Uint8List> _exportImage() async {
    final ByteData? data = await _drawingController.getImageData(
      format: ui.ImageByteFormat.png,
    );

    return data!.buffer.asUint8List();
  }

  String _exportJson() {
    final List<Map<String, dynamic>> jsonList = _drawingController.getJsonList();
    return JsonEncoder.withIndent('  ').convert(jsonList);
  }
}

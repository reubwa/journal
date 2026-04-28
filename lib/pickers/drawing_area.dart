import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

/*https://pub.dev/packages/flutter_drawing_board*/

class DrawingArea extends StatefulWidget {
  final Future Function(Uint8List, String) onDoodleFinished;
  final String? drawingJSON;
  const DrawingArea({super.key, required this.onDoodleFinished, this.drawingJSON});

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  final DrawingController _drawingController = DrawingController();
  bool isComp = false;

  @override
  void initState() {
    super.initState();
    if(widget.drawingJSON != null){
      _importJson(List<Map<String,dynamic>>.from(jsonDecode(widget.drawingJSON!)));
    }
    _drawingController.addListener(_onDrawingChanged);
  }

  void _onDrawingChanged() {
    if (mounted) {
      setState(() {
        isComp = _drawingController.getJsonList().isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _drawingController.removeListener(_onDrawingChanged);
    _drawingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add a Doodle"),
          leading: IconButton(onPressed: ()=>{Navigator.pop(context)}, icon: const Icon(Icons.close)),
          actions: [
            IconButton(onPressed: isComp ? () async {
              widget.onDoodleFinished(await _exportImage(), _exportJson());
              Navigator.pop(context);
            } : null, icon: const Icon(Icons.check))
          ],
        ),
        body: Column(
          children: [
            // Drawing Board
            Expanded(
              child: LayoutBuilder(
                  builder: (context, constraints) {
                    return DrawingBoard(
                      controller: _drawingController,
                      background: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        color: Colors.white,
                      ),
                    );
                  }
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

  void _importJson(List<Map<String, dynamic>> jsonData) {
    final contents = jsonData.map((json) {
      final type = json['type'] as String;
      switch (type) {
        case 'SimpleLine':
          return SimpleLine.fromJson(json);
        case 'StraightLine':
          return StraightLine.fromJson(json);
        case 'Rectangle':
          return Rectangle.fromJson(json);
        case 'Circle':
          return Circle.fromJson(json);
        case 'Eraser':
          return Eraser.fromJson(json);
        default:
          return null;
      }
    }).whereType<PaintContent>().toList();

    _drawingController.addContents(contents);
  }
}
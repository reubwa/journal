import 'package:flutter/material.dart';
import 'package:journalapp/database.dart';

class HeaderViewer extends StatelessWidget {
  final Block? headerBlock;
  const HeaderViewer({super.key, required this.headerBlock});

  @override
  Widget build(BuildContext context) {
    if (headerBlock == null) {
      return const ColoredBox(color: Colors.deepOrange);
    } else {
      switch (headerBlock!.type) {
        case BlockTypes.colouredblock:
          final parsedColour = int.tryParse(headerBlock!.txt ?? '');

          if (parsedColour != null) {
            return ColoredBox(color: Color(parsedColour));
          } else {
            return const ColoredBox(color: Colors.deepOrange);
          }
        case BlockTypes.image || BlockTypes.doodle:
          return Expanded(child:Image.memory(headerBlock!.image));
        case BlockTypes.text:
          return Expanded(
            child: ColoredBox(
              color: Colors.deepOrange,
              child: SizedBox(
                child: Text(headerBlock!.txt, style: TextStyle(color: Colors.white))
              ),
            ),
          );
        default:
          return const ColoredBox(color: Colors.deepOrange);
      }
    }
  }
}
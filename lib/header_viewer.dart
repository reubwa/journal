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
        case BlockTypes.image:
          return Image.memory(headerBlock!.image);
        default:
          return const ColoredBox(color: Colors.deepOrange);
      }
    }
  }
}
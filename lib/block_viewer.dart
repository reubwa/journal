import 'package:flutter/material.dart';
import 'package:journalapp/database.dart';

class BlockViewer extends StatelessWidget {
  final Block? headerBlock;
  final bool isExpanded;
  const BlockViewer({super.key, required this.headerBlock, required this.isExpanded});

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
        case BlockTypes.image || BlockTypes.doodle || BlockTypes.location:
          return SizedBox.expand(
            child: Image.memory(
              headerBlock!.image,
              fit: isExpanded? BoxFit.contain : BoxFit.cover,
            ),
          );
        case BlockTypes.text:
          return Text(headerBlock!.txt);
        default:
          return const ColoredBox(color: Colors.deepOrange);
      }
    }
  }
}
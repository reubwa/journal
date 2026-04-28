import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journalapp/database.dart';
import 'package:journalapp/block_viewer.dart';
/*https://docs.flutter.dev/cookbook/testing/widget/introduction*/
/*https://docs.flutter.dev/cookbook/testing/unit/introduction*/

void main() {
  group('BlockViewer Widget Tests', () {
    testWidgets('displays a deep orange ColoredBox when headerBlock is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BlockViewer(headerBlock: null, isExpanded: false),
          ),
        ),
      );

      final coloredBoxFinder = find.byType(ColoredBox);
      expect(coloredBoxFinder, findsWidgets);

      final ColoredBox coloredBox = tester.firstWidget(coloredBoxFinder);
      expect(coloredBox.color, Colors.deepOrange);
    });

    testWidgets('displays text when block type is text', (WidgetTester tester) async {
      final testTextBlock = Block(
        id: 1,
        type: BlockTypes.text,
        txt: 'Hello Journal',
        image: Uint8List(0),
        parentEntry: 1,
        positionAmongstSiblings: 1,
        isHeader: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlockViewer(headerBlock: testTextBlock, isExpanded: false),
          ),
        ),
      );

      expect(find.text('Hello Journal'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('displays an image with BoxFit.contain when isExpanded is true', (WidgetTester tester) async {
      final Uint8List dummyImageBytes = Uint8List.fromList([
        137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0,
        1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 11, 73, 68, 65,
        84, 8, 215, 99, 96, 0, 2, 0, 0, 5, 0, 1, 226, 38, 5, 155, 0, 0, 0, 0,
        73, 69, 78, 68, 174, 66, 96, 130
      ]);

      final testImageBlock = Block(
        id: 2,
        type: BlockTypes.image,
        txt: '',
        image: dummyImageBytes,
        parentEntry: 1,
        positionAmongstSiblings: 2,
        isHeader: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlockViewer(headerBlock: testImageBlock, isExpanded: true),
          ),
        ),
      );

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.fit, BoxFit.contain);

      expect(find.ancestor(of: imageFinder, matching: find.byType(SizedBox)), findsWidgets);
    });
  });
}
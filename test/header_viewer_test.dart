import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journalapp/database.dart';
import 'package:journalapp/header_viewer.dart';
/*https://docs.flutter.dev/cookbook/testing/widget/introduction*/
/*https://docs.flutter.dev/cookbook/testing/unit/introduction*/

void main() {
  group('HeaderViewer Widget Tests', () {
    testWidgets('displays a deep orange ColoredBox when headerBlock is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeaderViewer(headerBlock: null),
          ),
        ),
      );

      final coloredBoxFinder = find.byType(ColoredBox);
      expect(coloredBoxFinder, findsWidgets);

      final ColoredBox coloredBox = tester.firstWidget(coloredBoxFinder);
      expect(coloredBox.color, Colors.deepOrange);
    });

    testWidgets('displays text centrally when block type is text', (WidgetTester tester) async {
      final testBlock = Block(
        id: 1,
        type: BlockTypes.text,
        txt: 'My Test Header',
        image: Uint8List(0),
        parentEntry: 1,
        positionAmongstSiblings: 0,
        isHeader: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HeaderViewer(headerBlock: testBlock),
          ),
        ),
      );

      expect(find.text('My Test Header'), findsOneWidget);

      final textWidget = tester.widget<Text>(find.text('My Test Header'));
      expect(textWidget.style?.color, Colors.white);

      expect(find.ancestor(of: find.text('My Test Header'), matching: find.byType(Center)), findsOneWidget);
    });
  });
}